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
    var color: Color
    
    init(point: Point, imageWidth: CGFloat, imageHeight: CGFloat) {
        self.id = point.id!
        self.name = point.name!
        self.location = CGPoint(x: imageWidth * point.location.x, y: imageHeight * point.location.y)
        self.color = point.color
    }
    
    init(location: CGPoint) {
        self.id = UUID()
        self.name = ""
        self.location = location
        self.color = Color.black
    }
    
    init() {
        self.id = UUID()
        self.name = ""
        self.location = CGPoint(x: 0, y: 0)
        self.color = Color.black
    }
    
}
