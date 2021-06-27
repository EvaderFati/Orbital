//
//  WhereApp.swift
//  Where
//
//  Created by Evader on 24/6/21.
//

import SwiftUI

@main
struct WhereApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
