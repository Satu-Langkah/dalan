//
//  Item.swift
//  Dalan
//
//  Created by Jerry Febriano on 29/09/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var title: String
    var timestamp: Date
    
    init(title: String = "In app" ,timestamp: Date) {
        self.title = title
        self.timestamp = timestamp
    }
}
