//
//  ModelConfiguration+Shared.swift
//  Share
//
//  Created by Jerry Febriano on 29/09/25.
//

import Foundation
import SwiftData

extension ModelContainer {
    static func createSharedContainer() throws -> ModelContainer {
        let schema = Schema([Item.self])
        
        // Using App Group for shared storage between app and extension
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yoshi.Dalan")!.appendingPathComponent("default.store")
        let modelConfiguration = ModelConfiguration(schema: schema, url: containerURL)
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    }
}

