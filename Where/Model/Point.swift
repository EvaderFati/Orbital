//
//  Point.swift
//  Where
//
//  Created by Evader on 29/6/21.
//

import SwiftUI

extension Point {
    static func createPoint(_ newPoint: Point, pointVM: PointVM, x: Double, y: Double, photo: Photo) {
        newPoint.id = pointVM.id
        newPoint.name = pointVM.name
        newPoint.x = x
        newPoint.y = y
        newPoint.photo = photo
    }
    
    var location: CGPoint {
        return CGPoint(x: x, y: y)
    }
}
