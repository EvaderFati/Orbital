//
//  StoragerApp.swift
//  Storager
//
//  Created by Evader on 6/7/21.
//

import SwiftUI

@main
struct StoragerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
