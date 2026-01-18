//
//  LeketApp.swift
//  Leket
//
//  Created by RJ  Kigner on 1/13/26.
//

import SwiftUI
import CoreData

@main
struct LeketApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
