//
//  Helpers.swift
//  Pods
//
//  Created by Evangelos Pittas on 26/02/16.
//
//

import Foundation

class Helpers {
    
    class func getSuffixArrayFromArray(array: [AnyObject], index: Int) -> [AnyObject]? {
        
        if index > array.count-1 || index < 0 {
            return nil
        }
        
        var tmpArray: [AnyObject] = []
        
        for var i=0; i<array.count; i++ {
            if i >= index {
                tmpArray.append(array[i])
            }
        }
        
        return tmpArray
        
    }
    
}