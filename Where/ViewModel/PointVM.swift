//
//  PointVM.swift
//  Where
//
//  Created by Evader on 29/6/21.
//

import SwiftUI

struct PointVM: Identifiable {
    var id: UUID
    var name: String
    var location: CGPoint
    
    init(point: Point, imageWidth: CGFloat, imageHeight: CGFloat) {
        self.id = point.id!
        self.name = point.name!
        self.location = CGPoint(x: imageWidth * point.location.x, y: imageHeight * point.location.y)
        print(self.location)
        print("-- (\(imageWidth), \(imageHeight)) --")
    }
    
    init(location: CGPoint) {
        self.id = UUID()
        self.name = ""
        self.location = location
    }
    
    init() {
        self.id = UUID()
        self.name = ""
        self.location = CGPoint(x: 0, y: 0)
    }
    
//    func toPoint() -> Point {
//
//    }
}
