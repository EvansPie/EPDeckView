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

public class EPDeckViewAnimationManager {
    
    // MARK: CARDVIEW DRAGGING ANIMATION VARS
    //________________________________________________________________________________________
    
    //  The limit (on the x-axis) which the card being dragged will move out of the screen or
    //  back in its position. It's measured from the top card's center.
    public var actionMargin: CGFloat = 0.0
    
    //  The lower the rotation strength the larger the rotation angle of the card being dragged.
    public var rotationStrength: CGFloat = 320.0
    
    //  The max rotation angle of the card being dragged.
    public var rotationMax: CGFloat = 360.0
    
    //  This rotation angle will be achieved when the distance of the top card's center (i.e.
    //  the card being dragged) is equal to the rotationStrength.
    public var rotationAngle: CGFloat = 22.5
    
    public var scaleStrength: CGFloat = 4.0
    
    //  The max scaling percentage of the card being dragged. It takes values 0.0 ~> 1.0. E.g.
    //  if the scaleMax is 0.93 the minimum scaling that will be applied on the card is until
    //  it reached 7% of its original value.
    public var scaleMax: CGFloat = 0.93
    
    public var cardLeftFinishPoint: CGPoint  = CGPointZero
    public var cardRightFinishPoint: CGPoint = CGPointZero
    
    //  MARK: DECKVIEW ANIMATION VARS
    //________________________________________________________________________________________
    
    //  A reference to the DeckView that is the owner of this DeckViewAnimationManager.
    public var deckView: UIView?
    
    //  The animation duration of a card moving in/out of the screen, as well as the duration
    //  that the rest of the deck moves.
    public var deckAnimationDuration: NSTimeInterval = 0.3
    
    //  The corner that serves as the anchor point.
    public var deckAnchor: EPDeckViewAnchor = .BottomLeft
    
    //  The angle difference of the cards in the DeckView.
    public var deckCardAngleDelta: CGFloat = 7.0
    
    //  The scale difference (as a percentage) of the cards in the DeckView.
    public var deckViewCardScaleDelta: CGFloat = 0.08
    
    //  The transparancy difference of the cards in the DeckView. The last card is always
    //  completely transparent.
    public var deckCardAlphaDelta: CGFloat = 0.05
    
    //  The number of visible cards in the DeckView (provided that they are not transparent).
    public var deckMaxVisibleCards: Int = 5
    
    //  The deck's top card's center.
    public var deckCenter: CGPoint = CGPointZero
    
    public var frame: CGRect? {
        didSet {
            
        }
    }
    
    
    // MARK: - Initialization
    
    public init() {
        
    }

    public init(frame: CGRect) {
        self.frame = frame
        
        self.deckCenter = CGPointMake((self.frame!.origin.x + self.frame!.size.width/2), (self.frame!.origin.y + self.frame!.size.height/2))
        self.actionMargin = self.frame!.width / 2
        
        self.cardLeftFinishPoint = CGPointMake(-self.frame!.width * 1.5, self.frame!.height / 3.0)
        self.cardRightFinishPoint = CGPointMake(self.frame!.width * 1.5, self.frame!.height / 3.0)
    }
    
}





































