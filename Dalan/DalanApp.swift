//
//  DalanApp.swift
//  Dalan
//
//  Created by Jerry Febriano on 29/09/25.
//

import SwiftUI
import SwiftData

@main
struct DalanApp: App {
    var sharedModelContainer: ModelContainer = {
        do {
            return try ModelContainer.createSharedContainer()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
