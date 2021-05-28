//
//  OrbitalApp.swift
//  Orbital
//
//  Created by Evader on 11/5/21.
//

import SwiftUI

@main
struct OrbitalApp: App {
    @State private var location = Location.data
    
    init() {
        // Removing navigation bar bottom border
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LocationView(location: $location[0])
            }
        }
    }
}
