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
    
    init(point: Point) {
        self.id = point.id!
        self.name = point.name!
        self.location = point.screenLocation
    }
    
    init(location: CGPoint) {
        self.id = UUID()
        self.name = ""
        self.location = location
    }
    
//    func toPoint() -> Point {
//
//    }
}
