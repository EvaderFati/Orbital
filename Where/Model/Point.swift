//
//  Point.swift
//  Where
//
//  Created by Evader on 29/6/21.
//

import SwiftUI

extension Point {
    var location: CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    var screenLocation: CGPoint {
        let screenHeight = UIScreen.main.bounds.height
        let photoHeight = (photo?.image.size.height)!
        
        return CGPoint(x: CGFloat(x), y: CGFloat(y) + photoHeight/2 - screenHeight/2)
    }
}
