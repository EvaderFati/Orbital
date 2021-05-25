//
//  Location.swift
//  Orbital
//
//  Created by Evader on 25/5/21.
//

import Foundation

struct Location: Identifiable {
    let id: UUID
    var name: String
    var numOfItems: Int
    var locked: Bool
    var date: Date
    var locationsInside: [Location]?
    
    init(id: UUID = UUID(), name: String, numOfItems: Int, locked: Bool, date: Date, locationsInside: [Location]?) {
        self.id = id
        self.name = name
        self.numOfItems = numOfItems
        self.locked = locked
        self.date = date
        self.locationsInside = locationsInside
    }
}

extension Location {
    static var data: [Location] {
        [
            Location(name: "Home", numOfItems: 3, locked: false, date: Date(timeIntervalSinceNow: -237 * 86400), locationsInside: [
                Location(name: "Kitchen", numOfItems: 5, locked: false, date: Date(timeIntervalSinceNow: -178 * 86400), locationsInside: nil),
                Location(name: "Bedroom 1", numOfItems: 2, locked: true, date: Date(timeIntervalSinceNow: -168 * 86400), locationsInside: nil),
                Location(name: "Bedroom 2", numOfItems: 3, locked: true, date: Date(timeIntervalSinceNow: -98 * 86400), locationsInside: nil)
                ]),
            Location(name: "Workplace", numOfItems: 2, locked: true, date: Date(timeIntervalSinceNow: -293 * 86400), locationsInside: nil)
        ]
    }
}
