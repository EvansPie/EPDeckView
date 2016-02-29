//
//  CardView.swift
//  EPDeckView
//
//  Created by Evangelos Pittas on 24/02/16.
//  Copyright © 2016 EP. All rights reserved.
//
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation
import UIKit

// MARK: - DECKVIEW DATA SOURCE
//_______________________________________________________________________________________________________________
//  This protocol provides the two basic (and required) functions to create the DeckView. It works exactly as a
//  UITableView.
//
//  numberOfCardsInDeckView(_:) returns the number of cards that the DeckView will hold.
//
//  deckView(_:, cardViewAtIndex:) returns the view (that must be a subclass of the CardView) for each index.
//

@objc public protocol EPDeckViewDataSource : NSObjectProtocol {
    func numberOfCardsInDeckView(deckView: EPDeckView) -> Int
    func deckView(deckView: EPDeckView, cardViewAtIndex index: Int) -> EPCardView
}


// MARK: - DECKVIEW DELEGATE
//_______________________________________________________________________________________________________________
//  This protocol consists of five optional functions to help with the cards' movement.
//

@objc public protocol EPDeckViewDelegate : NSObjectProtocol {
    
    //  The function below is called when a card moves outside of the screen, and also specifies if the card has
    //  moved left or right.
    optional func deckView(deckView: EPDeckView, cardAtIndex index: Int, movedToDirection direction: CardViewDirection)
    
    //  The function below returns the button that implements the functionality to move the card to the right.
    //  Each card can have its' own button.
    optional func deckView(deckView: EPDeckView, rightButtonForCardAtIndex index: Int) -> UIButton?
    
    //  The function below returns the button that implements the functionality to move the card to the left.
    //  Each card can have its' own button.
    optional func deckView(deckView: EPDeckView, leftButtonForCardAtIndex index: Int) -> UIButton?
    
    //  The function below is called when the button with the move right functionality is tapped.
    optional func deckView(deckView: EPDeckView, didTapRightButtonAtIndex index: Int)
    
    //  The function below is called when the button with the move left functionality is tapped.
    optional func deckView(deckView: EPDeckView, didTapLeftButtonAtIndex index: Int)
}


// MARK: - DECKVIEW
//_______________________________________________________________________________________________________________
//

public class EPDeckView: UIView {
    
    // MARK: Properties
    
    //  The animation manager holds the vars for the card dragging and deck view animations.
    public var deckViewAnimationManager: EPDeckViewAnimationManager! {
        didSet {
            self.allowDeckViewAnimationManagerModify = false
        }
    }
    
    private var allowDeckViewAnimationManagerModify: Bool = true
    
    //  Holds the index of the top card on the deck view.
    private(set) var topCardIndex: Int = 0 {
        didSet {
            for cardView in self.deck {
                cardView.userInteractionEnabled = false
            }
            
            if self.topCardIndex < self.deck.count {
                self.deck[self.topCardIndex].userInteractionEnabled = true
            }
        }
    }
    
    //  Calculated cards' tranformations (angle, scale, alpha & center position) are stored in these arrays.
    private(set) var deck: [EPCardView] = []
    private(set) var cardAnglesDegrees: [CGFloat] = []
    private(set) var cardScalePercentages: [CGFloat] = []
    private(set) var cardAlphas: [CGFloat] = []
    private(set) var transformedCardCenters: [CGPoint] = []
    
    //  The delegate & data source.
    public var delegate: EPDeckViewDelegate?
    public var dataSource: EPDeckViewDataSource?
    
    
    //  MARK: - DeckView Initialization
    
    public required override init(frame: CGRect) {
        super.init(frame: frame)
        self.addObserver(self, forKeyPath: "center", options: NSKeyValueObservingOptions.Old, context: nil)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.addObserver(self, forKeyPath: "center", options: NSKeyValueObservingOptions.Old, context: nil)
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "frame")
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {

        if keyPath != nil && object != nil {
            if keyPath! == "center" && self == object as? EPDeckView {
                
                if self.allowDeckViewAnimationManagerModify == true {
                    // Initialize the default DeckViewAnimationManager. It may be replaced afterwards.
                    self.deckViewAnimationManager = EPDeckViewAnimationManager(frame: self.frame)
                }
                
            }
        }
    }
    
    
    //  MARK: - CardView Functions
    
    //  The function reloadCards clears the DeckView and reloads the cards. It works as UITableView's reload data.
    public func reloadCards() {
        for card in self.deck {
            card.removeFromSuperview()
        }
        
        if self.deckViewAnimationManager == nil {
            self.deckViewAnimationManager = EPDeckViewAnimationManager(frame: self.frame)
        }
        
        self.deck = []
        
        for var i=0; i<self.dataSource?.numberOfCardsInDeckView(self); i++ {
            let cardView: EPCardView = self.dataSource!.deckView(self, cardViewAtIndex: i)
            cardView.center = self.deckViewAnimationManager.deckCenter
            cardView.delegate = self
            
            if let rightButton: UIButton = self.delegate?.deckView?(self, rightButtonForCardAtIndex: i) {
                rightButton.tag = i
                rightButton.addTarget(self, action: Selector("rightButtonTapped:"), forControlEvents: .TouchUpInside)
            }
            
            if let leftButton: UIButton = self.delegate?.deckView?(self, leftButtonForCardAtIndex: i) {
                leftButton.tag = i
                leftButton.addTarget(self, action: Selector("leftButtonTapped:"), forControlEvents: .TouchUpInside)
            }
            
            self.deck.append(cardView)
        }
        
        self.applyCardViewsInitialTransformation()
        
        for var i=self.deck.count-1; i>=0; i-- {
            let cardView: EPCardView = self.deck[i]
            cardView.alpha = self.cardAlphas[i]
            self.addSubview(cardView)
        }
        
        self.topCardIndex = 0
    }
    
    //  The function moveCardAtIndex(_:, direction:) moves the specified card of the index to the direction given
    //  (i.e. left or right).
    public func moveCardAtIndex(index: Int, toDirection direction: CardViewDirection) {
        let cardView: EPCardView = self.deck[index]
        
        switch direction {
        case .Right:
            cardView.moveToRight()
            break
        case .Left:
            cardView.moveToLeft()
            break
        }
    }
    
    //  The function moveTopCardToDirection(_:) moves the top card of the deck to the direction given (i.e. left
    //  or right).
    public func moveTopCardToDirection(direction: CardViewDirection) {
        let cardView: EPCardView = self.deck[self.topCardIndex]
        
        switch direction {
        case .Right:
            cardView.moveToRight()
            break
        case .Left:
            cardView.moveToLeft()
            break
        }
    }
    
    //  The function moveMovedCardBackToDeckViewTop() moves the the last card that left the deck, back to the top
    //  of the DeckView.
    public func bringBackLastCardThrown() {
        if self.topCardIndex > 0 {
            if let lastMovedCardView: EPCardView = self.deck[self.topCardIndex-1] {
                lastMovedCardView.moveToCenter()
            }
        }
    }
    
    //  The selector function of the delegate's right movement button that is returned by:
    //  deckView(_:, rightButtonForIndex:)
    @objc private func rightButtonTapped(sender: UIButton) {
        self.moveCardAtIndex(sender.tag, toDirection: .Right)
        self.delegate?.deckView?(self, didTapRightButtonAtIndex: sender.tag)
    }
    
    //  The selector function of the delegate's left movement button that is returned by:
    //  deckView(_:, leftButtonForIndex:)
    @objc private func leftButtonTapped(sender: UIButton) {
        self.moveCardAtIndex(sender.tag, toDirection: .Left)
        self.delegate?.deckView?(self, didTapLeftButtonAtIndex: sender.tag)
    }
    
    
    //  MARK: - Initial CardViews Transformations
    
    //  Calculate the angle, scale & alpha for each card and apply its transformation.
    private func applyCardViewsInitialTransformation() {
        self.calculateCardAngles()
        self.calculateCardScales()
        self.calculateCardAlphas()
        self.transformCards()
        
        NSNotificationCenter.defaultCenter().postNotificationName("kCardViewsTransformationCompleted", object: nil, userInfo: nil)
    }
    
    //  Calculate each card's angle (based on the DeckViewAnimationManager) and store them in an array.
    private func calculateCardAngles() {
        var tmpComputedCardAngles: [CGFloat] = []
        
        for (i, _) in self.deck.enumerate() {
            let tmpCardAngle = CGFloat(i) * self.deckViewAnimationManager.deckCardAngleDelta
            tmpComputedCardAngles.append(tmpCardAngle)
        }
        
        self.cardAnglesDegrees = tmpComputedCardAngles
    }
    
    //  Calculate each card's scale (based on the DeckViewAnimationManager) and store them in an array.
    private func calculateCardScales() {
        var tmpComputedCardScalePercentages: [CGFloat] = []
        
        for (i, _) in self.deck.enumerate() {
            var tmpCardScale = 1 - CGFloat(i) * self.deckViewAnimationManager.deckViewCardScaleDelta
            
            if tmpCardScale > 1.0 {
                tmpCardScale = 1.0
            }
            
            if tmpCardScale < 0 {
                tmpCardScale = 0
            }
            
            tmpComputedCardScalePercentages.append(tmpCardScale)
        }
        
        self.cardScalePercentages = tmpComputedCardScalePercentages
    }
    
    //  Calculate each card's transparency (based on the DeckViewAnimationManager) and store them in an array.
    private func calculateCardAlphas() {
        var tmpComputedCardAlphas: [CGFloat] = []
        
        for (i, _) in self.deck.enumerate() {
            var tmpCardAlpha = 1 - CGFloat(i) * self.deckViewAnimationManager.deckCardAlphaDelta
            
            if tmpCardAlpha > 1.0 {
                tmpCardAlpha = 1.0
            }
            
            if tmpCardAlpha < 0 {
                tmpCardAlpha = 0
            }
            
            if i >= self.deckViewAnimationManager.deckMaxVisibleCards {
                tmpCardAlpha = 0
            }
            
            tmpComputedCardAlphas.append(tmpCardAlpha)
        }
        
        if tmpComputedCardAlphas.count > 0 {
            tmpComputedCardAlphas[tmpComputedCardAlphas.count - 1] = 0.0
        }
        
        self.cardAlphas = tmpComputedCardAlphas
    }
    
    //  Apply each card's transformation based on angle, scale and anchor point and store their new centers
    //  in the property array.
    private func transformCards() {
        self.transformedCardCenters = []
        
        for (i, cardView) in self.deck.enumerate() {
            cardView.transform = self.getCardViewTransformForIndex(i)
            cardView.anchorTo(self.deckViewAnimationManager.deckAnchor)
            self.transformedCardCenters.append(cardView.center)
        }
        
    }
    
    //  Store each card's transformation.
    private func getCardViewTransformForIndex(index: Int) -> CGAffineTransform {
        return CGAffineTransformScale(
            CGAffineTransformMakeRotation(self.cardAnglesDegrees[index].toRad()),
            self.cardScalePercentages[index],
            self.cardScalePercentages[index])
    }
}



//  MARK: - CARDVIEW DELEGATE

extension EPDeckView: EPCardViewDelegate {
    
    //  The card is being dragged, so move the rest of the cards accordingly.
    func cardView(cardView: EPCardView, beingDragged gestureRecognizer: UIPanGestureRecognizer) {
        let xFromCenter:CGFloat = gestureRecognizer.translationInView(cardView).x
        
        let maxMovement: CGFloat = self.bounds.width / 2.0
        let transformPercentage: CGFloat = min(fabs(xFromCenter) / maxMovement, 1.0) // 0.0 ~> 1.0
        
        switch gestureRecognizer.state {
        case UIGestureRecognizerState.Changed:
            
            let cardViewsToTransform: [EPCardView] = Array(self.deck.suffixFrom(self.topCardIndex))

            for (i, cardViewToTransform) in cardViewsToTransform.enumerate() {
                if i == 0 {
                    continue
                }
                
                let rotationAngle: CGFloat = (self.cardAnglesDegrees[i-1] - self.deckViewAnimationManager.deckCardAngleDelta * transformPercentage + self.deckViewAnimationManager.deckCardAngleDelta).toRad()
                let rotationAngleTransform: CGAffineTransform = CGAffineTransformMakeRotation(rotationAngle)
                
                let scale: CGFloat = self.cardScalePercentages[i] + self.deckViewAnimationManager.deckViewCardScaleDelta * transformPercentage
                let scaleTransform: CGAffineTransform = CGAffineTransformScale(rotationAngleTransform, scale, scale)
                
                let moveX: CGFloat =  -transformPercentage * (self.transformedCardCenters[i].x - self.transformedCardCenters[i-1].x)
                let moveY: CGFloat =  -transformPercentage * (self.transformedCardCenters[i].y - self.transformedCardCenters[i-1].y)
                let moveTransform: CGAffineTransform = CGAffineTransformMakeTranslation(moveX, moveY)
                
                
                cardViewToTransform.transform = CGAffineTransformConcat(moveTransform, scaleTransform)
                
                cardViewToTransform.alpha = self.cardAlphas[i] + ((self.cardAlphas[i-1] - self.cardAlphas[i]) * transformPercentage)
            }
            
            break
        default:
            break
        }
    }
    
    //  The card has stopped being dragged, so move the rest of the cards accordingly.
    func cardView(cardView: EPCardView, afterSwipeMovedTo cardViewEndPoint: CardViewEndPoint) {
        
        if cardViewEndPoint == .Center {
            let cardViewsToTransform: [EPCardView] = Array(self.deck.suffixFrom(self.topCardIndex))
            
            for (i, cardViewToTransform) in cardViewsToTransform.enumerate() {
                UIView.animateWithDuration(self.deckViewAnimationManager.deckAnimationDuration,
                    delay: 0.0,
                    options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: {
                        let rotationAngle: CGFloat = self.cardAnglesDegrees[i].toRad()
                        let rotationAngleTransform: CGAffineTransform = CGAffineTransformMakeRotation(rotationAngle)
                        
                        let scale: CGFloat = self.cardScalePercentages[i]
                        let scaleTransform: CGAffineTransform = CGAffineTransformScale(rotationAngleTransform, scale, scale)
                        
                        cardViewToTransform.center = self.transformedCardCenters[i]
                        
                        cardViewToTransform.transform = scaleTransform
                        
                        cardViewToTransform.alpha = self.cardAlphas[i]
                        
                    },
                    completion: nil
                )
            }
            
        }
        
    }
    
    //  The card moves out of the screen (left or right).
    func cardView(cardView: EPCardView, movingToDirection direction: CardViewDirection) {
        let cardViewsToTransform: [EPCardView] = Array(self.deck.suffixFrom(self.topCardIndex))
        
        for (i, cardViewToTransform) in cardViewsToTransform.enumerate() {
            if i == 0 {
                continue
            }
            
            UIView.animateWithDuration(self.deckViewAnimationManager.deckAnimationDuration,
                delay: 0.0,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    let rotationAngle: CGFloat = self.cardAnglesDegrees[i-1].toRad()
                    let rotationAngleTransform: CGAffineTransform = CGAffineTransformMakeRotation(rotationAngle)
                    
                    let scale: CGFloat = self.cardScalePercentages[i-1]
                    let scaleTransform: CGAffineTransform = CGAffineTransformScale(rotationAngleTransform, scale, scale)
                    
                    cardViewToTransform.center = self.transformedCardCenters[i-1]
                    
                    cardViewToTransform.transform = scaleTransform
                    
                    cardViewToTransform.alpha = self.cardAlphas[i-1]
                    
                },
                completion: nil
            )
        }
        
        self.topCardIndex++
        
        self.delegate?.deckView?(self, cardAtIndex: self.topCardIndex, movedToDirection: direction)
    }
    
    func cardView(cardView: EPCardView, cardViewMovedTo cardViewEndPoint: CardViewEndPoint) {
        let cardViewsToTransform: [EPCardView] = Array(self.deck.suffixFrom(self.topCardIndex))
        
        for (i, cardViewToTransform) in cardViewsToTransform.enumerate() {
            
            UIView.animateWithDuration(self.deckViewAnimationManager.deckAnimationDuration,
                delay: 0.0,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    let rotationAngle: CGFloat = self.cardAnglesDegrees[i+1].toRad()
                    let rotationAngleTransform: CGAffineTransform = CGAffineTransformMakeRotation(rotationAngle)
                    
                    let scale: CGFloat = self.cardScalePercentages[i+1]
                    let scaleTransform: CGAffineTransform = CGAffineTransformScale(rotationAngleTransform, scale, scale)
                    
                    cardViewToTransform.center = self.transformedCardCenters[i+1]
                    
                    cardViewToTransform.transform = scaleTransform
                    
                    cardViewToTransform.alpha = self.cardAlphas[i+1]
                    
                },
                completion: nil
            )
        }
        
        self.topCardIndex--
    }
}


























