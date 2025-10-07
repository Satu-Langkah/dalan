//
//  URLValidator.swift
//  Share
//
//  Created by Jerry Febriano on 29/09/25.
//

import Foundation

protocol URLValidating {
    func validateURL(_ urlString: String) -> (isValid: Bool, platform: LinkPlatform?)
}

final class URLValidator: URLValidating {
    
    func validateURL(_ urlString: String) -> (isValid: Bool, platform: LinkPlatform?) {
        guard let url = URL(string: urlString),
              let host = url.host?.lowercased() else {
            return (false, nil)
        }
        
        // TikTok validation
        if host.contains("tiktok.com") || host.contains("vt.tiktok.com") {
            return (true, .tiktok)
        }
        
        // Instagram validation (Reels)
        if (host.contains("instagram.com") || host.contains("instagr.am")) &&
           (urlString.contains("/reel/") || urlString.contains("/reels/")) {
            return (true, .instagram)
        }
        
        // YouTube Shorts validation
        if (host.contains("youtube.com") || host.contains("youtu.be")) &&
           urlString.contains("/shorts/") {
            return (true, .youtubeShorts)
        }
        
        return (false, nil)
    }
}

