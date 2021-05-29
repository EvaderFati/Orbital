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
    var isFolder: Bool
    var numOfItems: Int
    var locked: Bool
    var date: Date
    var locationsInside: [Location]
    
    init(id: UUID = UUID(), name: String, isFolder: Bool, numOfItems: Int, locked: Bool, date: Date, locationsInside: [Location]) {
        self.id = id
        self.name = name
        self.isFolder = isFolder
        self.numOfItems = numOfItems
        self.locked = locked
        self.date = date
        self.locationsInside = locationsInside
    }
}

extension Location {
    static var data: [Location] {
        [
            Location(name: "Home", isFolder: true, numOfItems: 3, locked: false, date: Date(timeIntervalSinceNow: -237 * 86400), locationsInside: [
                Location(name: "Kitchen", isFolder: false, numOfItems: 5, locked: false, date: Date(timeIntervalSinceNow: -178 * 86400), locationsInside: [
                    Location(name: "Bedroom 1", isFolder: true, numOfItems: 2, locked: true, date: Date(timeIntervalSinceNow: -167 * 86400), locationsInside: []),
                    Location(name: "Bedroom 2", isFolder: true, numOfItems: 3, locked: true, date: Date(timeIntervalSinceNow: -99 * 86400), locationsInside: [])
                ]),
                Location(name: "Bedroom 1", isFolder: true, numOfItems: 2, locked: true, date: Date(timeIntervalSinceNow: -168 * 86400), locationsInside: []),
                Location(name: "Bedroom 2", isFolder: true, numOfItems: 3, locked: true, date: Date(timeIntervalSinceNow: -98 * 86400), locationsInside: []),
                Location(name: "Kitchen", isFolder: true, numOfItems: 5, locked: false, date: Date(timeIntervalSinceNow: -178 * 86400), locationsInside: []),
                Location(name: "Bedroom 1", isFolder: true, numOfItems: 2, locked: true, date: Date(timeIntervalSinceNow: -168 * 86400), locationsInside: []),
                Location(name: "Bedroom 2", isFolder: true, numOfItems: 3, locked: true, date: Date(timeIntervalSinceNow: -98 * 86400), locationsInside: []),
                Location(name: "Kitchen", isFolder: true, numOfItems: 5, locked: false, date: Date(timeIntervalSinceNow: -178 * 86400), locationsInside: []),
                Location(name: "Bedroom 1", isFolder: true, numOfItems: 2, locked: true, date: Date(timeIntervalSinceNow: -168 * 86400), locationsInside: []),
                Location(name: "Bedroom 2", isFolder: true, numOfItems: 3, locked: true, date: Date(timeIntervalSinceNow: -98 * 86400), locationsInside: [])
                ]),
            Location(name: "Workplace", isFolder: true, numOfItems: 2, locked: true, date: Date(timeIntervalSinceNow: -293 * 86400), locationsInside: []),
            Location(name: "Luggage", isFolder: true, numOfItems: 3, locked: false, date: Date(timeIntervalSinceNow: 108 * 86400), locationsInside: [])
        ]
    }
}

extension Location {
    struct Data {
        var name: String = ""
        var locked: Bool = false
    }
    
    var data: Data {
        return Data(name: name, locked: locked)
    }
}
