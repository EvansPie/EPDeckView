//
//  CardCell.swift
//  EPDeckView
//
//  Created by Evangelos Pittas on 24/02/16.
//  Copyright © 2016 EP. All rights reserved.
//
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation
import UIKit


protocol EPCardViewDelegate {
    func cardView(cardView: EPCardView, beingDragged gestureRecognizer: UIPanGestureRecognizer)
    func cardView(cardView: EPCardView, afterSwipeMovedTo cardViewEndPoint: CardViewEndPoint)
    func cardView(cardView: EPCardView, movingToDirection direction: CardViewDirection)
    func cardView(cardView: EPCardView, cardViewMovedTo cardViewEndPoint: CardViewEndPoint)
}


@objc public enum CardViewEndPoint: Int {
    case Left = 0, Center, Right
}

@objc public enum CardViewDirection: Int {
    case Left = 0, Right
    
    public func description() -> String {
        switch self {
        case .Left:
            return ".Left"
        case .Right:
            return ".Right"
        }
    }
}


public class EPCardView: UIView {
    
    var delegate: EPCardViewDelegate?
    
    // MARK: - INITIALIZATION
    public required override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.removeAllGestureRecognizers()
        
        let panGesture:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action:Selector("cardViewBeingDragged:"))
        self.addGestureRecognizer(panGesture)
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.removeAllGestureRecognizers()
        
        let panGesture:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action:Selector("cardViewBeingDragged:"))
        self.addGestureRecognizer(panGesture)
    }
    
    private func removeAllGestureRecognizers() {
        if self.gestureRecognizers != nil {
            for gesture in self.gestureRecognizers! {
                self.removeGestureRecognizer(gesture)
            }
        }
    }
    
    func cardViewBeingDragged(gestureRecognizer: UIPanGestureRecognizer) {
        let xFromCenter:CGFloat = gestureRecognizer.translationInView(self).x
        let yFromCenter:CGFloat = gestureRecognizer.translationInView(self).y
        
        switch gestureRecognizer.state {
        case UIGestureRecognizerState.Changed:
            
            // Calculate the rotation angle with the movement.
            let rotationStrength: CGFloat = min(xFromCenter / (self.delegate as! EPDeckView).deckViewAnimationManager.rotationStrength, (self.delegate as! EPDeckView).deckViewAnimationManager.rotationMax)
            
            let rotationAngle: CGFloat = CGFloat((self.delegate as! EPDeckView).deckViewAnimationManager.rotationAngle * rotationStrength).toRad()
            
            // Calculate the scale percentage with the movement.
            let scale: CGFloat = max(1 - fabs(rotationStrength) / (self.delegate as! EPDeckView).deckViewAnimationManager.scaleStrength, (self.delegate as! EPDeckView).deckViewAnimationManager.scaleMax)
            
            // Move the card's center along with the gesure.
            self.center = CGPointMake((self.delegate as! EPDeckView).deckViewAnimationManager.deckCenter.x + xFromCenter, (self.delegate as! EPDeckView).deckViewAnimationManager.deckCenter.y + yFromCenter);
            
            let angleTransform: CGAffineTransform = CGAffineTransformMakeRotation(rotationAngle)
            let scaleTransform: CGAffineTransform = CGAffineTransformScale(angleTransform, scale, scale)
            
            // Apply the scale & rotation transformation.
            self.transform = scaleTransform;
            break
        case UIGestureRecognizerState.Ended:
            self.afterSwipeAction(xFromCenter, yFromCenter: yFromCenter)
            break
        default:
            break
        }
        
        self.delegate?.cardView(self, beingDragged: gestureRecognizer)
    }
    
    func afterSwipeAction(xFromCenter: CGFloat, yFromCenter: CGFloat) {
        if xFromCenter > (self.delegate as! EPDeckView).deckViewAnimationManager.actionMargin {
            self.moveToRight(xFromCenter: xFromCenter, yFromCenter: yFromCenter)
            self.delegate?.cardView(self, afterSwipeMovedTo: .Right)
            
        } else if xFromCenter < -(self.delegate as! EPDeckView).deckViewAnimationManager.actionMargin {
            self.moveToLeft(xFromCenter: xFromCenter, yFromCenter: yFromCenter)
            self.delegate?.cardView(self, afterSwipeMovedTo: .Left)
            
        } else {
            UIView.animateWithDuration((self.delegate as! EPDeckView).deckViewAnimationManager.deckAnimationDuration,
                animations: { finished in
                    self.center = (self.delegate as! EPDeckView).deckViewAnimationManager.deckCenter
                    self.transform = CGAffineTransformMakeRotation(0)
            })
            
            self.delegate?.cardView(self, afterSwipeMovedTo: .Center)
        }
    }
    
    func moveToRight(xFromCenter xFromCenter: CGFloat? = nil, yFromCenter: CGFloat? = nil) {
        let finishPoint: CGPoint = (self.delegate as! EPDeckView).deckViewAnimationManager.cardRightFinishPoint
        
        UIView.animateWithDuration((self.delegate as! EPDeckView).deckViewAnimationManager.deckAnimationDuration, animations: {
            self.center = finishPoint
            self.transform = CGAffineTransformMakeRotation(1)
            
            }, completion: { finished in
                
        })
        
        self.delegate?.cardView(self, movingToDirection: .Right)
    }
    
    func moveToLeft(xFromCenter xFromCenter: CGFloat? = nil, yFromCenter: CGFloat? = nil) {
        let finishPoint: CGPoint = (self.delegate as! EPDeckView).deckViewAnimationManager.cardLeftFinishPoint
        
        UIView.animateWithDuration((self.delegate as! EPDeckView).deckViewAnimationManager.deckAnimationDuration,
            animations: {
                self.center = finishPoint
                self.transform = CGAffineTransformMakeRotation(1)
            }, completion: { finished in
                
        })
        
        self.delegate?.cardView(self, movingToDirection: .Left)
    }
    
    func moveToCenter() {
        let finishPoint: CGPoint = (self.delegate as! EPDeckView).deckViewAnimationManager.deckCenter
        
        UIView.animateWithDuration((self.delegate as! EPDeckView).deckViewAnimationManager.deckAnimationDuration,
            animations: {
                self.center = finishPoint
                self.transform = CGAffineTransformMakeRotation(0)
            }, completion: { finished in
                
        })
        
        self.delegate?.cardView(self, cardViewMovedTo: .Center)
    }
}


































