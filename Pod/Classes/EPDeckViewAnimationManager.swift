//
//  DeckViewAnimationManager.swift
//  EPDeckView
//
//  Created by Evangelos Pittas on 25/02/16.
//  Copyright © 2016 EP. All rights reserved.
//
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation
import UIKit

class EPDeckViewAnimationManager {
    
    // MARK: CARDVIEW DRAGGING ANIMATION VARS
    //________________________________________________________________________________________
    
    //  The limit (on the x-axis) which the card being dragged will move out of the screen or
    //  back in its position. It's measured from the top card's center.
    var actionMargin: CGFloat = 0.0
    
    //  The lower the rotation strength the larger the rotation angle of the card being dragged.
    var rotationStrength: CGFloat = 320.0
    
    //  The max rotation angle of the card being dragged.
    var rotationMax: CGFloat = 360.0
    
    //  This rotation angle will be achieved when the distance of the top card's center (i.e.
    //  the card being dragged) is equal to the rotationStrength.
    var rotationAngle: CGFloat = 22.5
    
    var scaleStrength: CGFloat = 4.0
    
    //  The max scaling percentage of the card being dragged. It takes values 0.0 ~> 1.0. E.g.
    //  if the scaleMax is 0.93 the minimum scaling that will be applied on the card is until
    //  it reached 7% of its original value.
    var scaleMax: CGFloat = 0.93
    
    var cardLeftFinishPoint: CGPoint  = CGPointZero
    var cardRightFinishPoint: CGPoint = CGPointZero
    
    //  MARK: DECKVIEW ANIMATION VARS
    //________________________________________________________________________________________
    
    //  A reference to the DeckView that is the owner of this DeckViewAnimationManager.
    var deckView: UIView?
    
    //  The animation duration of a card moving in/ou of the screen, as well as the duration
    //  that the rest of the deck moves.
    var deckViewAnimationDuration: NSTimeInterval = 0.3
    
    //  The corner that serves as the anchor point.
    var deckViewAnchor: EPDeckViewAnchor = .BottomLeft
    
    //  The angle difference of the cards in the DeckView.
    var deckViewCardAngleDelta: CGFloat = 7.0
    
    //  The scale difference (as a percentage) of the cards in the DeckView.
    var deckViewCardScaleDelta: CGFloat = 0.08
    
    //  The transparancy difference of the cards in the DeckView. The last card is always
    //  completely transparent.
    var deckViewCardAlphaDelta: CGFloat = 0.05
    
    //  The number of visible cards in the DeckView (provided that they are not transparent).
    var deckViewMaxVisibleCards: Int = 5
    
    //  The deck's top card's center.
    var deckViewCenter: CGPoint = CGPointZero
    
    
    // MARK: - Initialization
    init() {
        self.deckView = nil
        self.deckViewCenter = CGPointMake(UIScreen.mainScreen().bounds.size.width/2, UIScreen.mainScreen().bounds.size.height/2)
        self.actionMargin = UIScreen.mainScreen().bounds.size.width/2
        
        self.cardLeftFinishPoint = CGPointMake(-UIScreen.mainScreen().bounds.size.width * 1.5, UIScreen.mainScreen().bounds.size.height / 3.0)
        self.cardRightFinishPoint = CGPointMake(UIScreen.mainScreen().bounds.size.width * 1.5, UIScreen.mainScreen().bounds.size.height / 3.0)
    }
    
    
    init(deckView: UIView) {
        self.deckView = deckView
        self.deckViewCenter = self.deckView!.center
        self.actionMargin = self.deckView!.bounds.width / 2
        
        self.cardLeftFinishPoint = CGPointMake(-self.deckView!.bounds.width * 1.5, self.deckView!.bounds.height / 3.0)
        self.cardRightFinishPoint = CGPointMake(self.deckView!.bounds.width * 1.5, self.deckView!.bounds.height / 3.0)
    }
    
}





































