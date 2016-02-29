//
//  Extensions.swift
//  EPDeckView
//
//  Created by Evangelos Pittas on 24/02/16.
//  Copyright © 2016 EP. All rights reserved.
//
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation
import UIKit

public enum EPDeckViewAnchor {
    case TopLeft, TopRight, BottomRight, BottomLeft
}

extension UIView {
    
    //  Setting the anchor point to any of the four values (TopLeft, TopRight, BottomRight,
    //  BottomLeft) changes the view's center, in order for the transformed views to be aligned
    //  correctly in the chosen corner.
    func anchorTo(viewAnchor: EPDeckViewAnchor) {
        
        switch viewAnchor {
        case .TopLeft:
            let centerOffsetX: CGFloat = self.originalFrame().origin.x - self.transformedTopLeft().x
            self.center.x += centerOffsetX
            let centerOffsetY: CGFloat = self.originalFrame().origin.y - self.transformedTopLeft().y
            self.center.y += centerOffsetY
            break
            
        case .TopRight:
            let centerOffsetX: CGFloat = self.originalFrame().origin.x + self.originalFrame().size.width - self.transformedTopRight().x
            self.center.x += centerOffsetX
            let centerOffsetY: CGFloat = self.originalFrame().origin.y - self.transformedTopRight().y
            self.center.y += centerOffsetY
            break
            
        case .BottomLeft:
            let centerOffsetX: CGFloat = self.originalFrame().origin.x - self.transformedBottomLeft().x
            self.center.x += centerOffsetX
            let centerOffsetY: CGFloat = self.originalFrame().origin.y + self.originalFrame().size.height - self.transformedBottomLeft().y
            self.center.y += centerOffsetY
            break
            
        case .BottomRight:
            let centerOffsetX: CGFloat = self.originalFrame().origin.x + self.originalFrame().size.width - self.transformedBottomRight().x
            self.center.x += centerOffsetX
            let centerOffsetY: CGFloat = self.originalFrame().origin.y + self.originalFrame().size.height - self.transformedBottomRight().y
            self.center.y += centerOffsetY
            break
            
        }
        
    }
    
    //  Returns the offset x, y, as a CGPoint, of the point provided compared to
    //  the view's center.
    func offsetPointToParentCoordinates(aPoint: CGPoint) -> CGPoint {
        return CGPointMake(aPoint.x + self.center.x, aPoint.y + self.center.y)
    }
    
    //  Returns the point as a reference to the view's center.
    func pointInViewCenterTerms(aPoint: CGPoint) -> CGPoint {
        return CGPointMake(aPoint.x - self.center.x, aPoint.y - self.center.y)
    }
    
    //  Returns the point as a reference to the transformed view's center.
    func pointInTransformedView(aPoint: CGPoint) -> CGPoint {
        let offsetItem: CGPoint = self.pointInViewCenterTerms(aPoint)
        let updatedItem: CGPoint = CGPointApplyAffineTransform(offsetItem, self.transform)
        
        let finalItem: CGPoint = self.offsetPointToParentCoordinates(updatedItem)
        return finalItem
    }
    
    //  Returns the frame of the view before any transformation took place.
    func originalFrame() -> CGRect {
        let currentTransform: CGAffineTransform = self.transform
        self.transform = CGAffineTransformIdentity
        let originalFrame: CGRect = self.frame
        self.transform = currentTransform
        return originalFrame
    }
    
    //  Returns the top left corner of the transformed view.
    func transformedTopLeft() -> CGPoint {
        let frame: CGRect = self.originalFrame()
        let point: CGPoint = frame.origin
        return self.pointInTransformedView(point)
    }
    
    //  Returns the top right corner of the transformed view.
    func transformedTopRight() -> CGPoint {
        let frame: CGRect = self.originalFrame()
        var point: CGPoint = frame.origin
        point.x += frame.size.width
        return self.pointInTransformedView(point)
    }
    
    //  Returns the bottom right corner of the transformed view.
    func transformedBottomRight() -> CGPoint {
        let frame: CGRect = self.originalFrame()
        var point: CGPoint = frame.origin
        point.x += frame.size.width
        point.y += frame.size.height
        return self.pointInTransformedView(point)
    }
    
    //  Returns the bottom left corner of the transformed view.
    func transformedBottomLeft() -> CGPoint {
        let frame: CGRect = self.originalFrame()
        var point: CGPoint = frame.origin
        point.y += frame.size.height
        return self.pointInTransformedView(point)
    }
    
}


extension CGFloat {
    
    //  Converts degrees to rads.
    func toRad() -> CGFloat {
        return self * CGFloat(M_PI) / 180.0
    }
    
}







