//
//  Item.swift
//  Share
//
//  Created by Jerry Febriano on 29/09/25.
//

import Foundation
import SwiftData

enum LinkPlatform: String, Codable {
    case tiktok = "TikTok"
    case instagram = "Instagram"
    case youtubeShorts = "YouTube Shorts"
    case unknown = "Unknown"
}

@Model
final class Item {
    var url: String
    var platform: String
    var timestamp: Date
    var title: String?
    
    init(url: String, platform: LinkPlatform, timestamp: Date = Date(), title: String? = nil) {
        self.url = url
        self.platform = platform.rawValue
        self.timestamp = timestamp
        self.title = title
    }
    
    var platformEnum: LinkPlatform {
        LinkPlatform(rawValue: platform) ?? .unknown
    }
}

