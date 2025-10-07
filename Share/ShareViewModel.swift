//
//  ShareViewModel.swift
//  Share
//
//  Created by Jerry Febriano on 29/09/25.
//

import Foundation
import SwiftData
import Combine

@MainActor
final class ShareViewModel: ObservableObject {
    
    @Published var isProcessing: Bool = false
    @Published var errorMessage: String?
    
    private let urlValidator: URLValidating
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext, urlValidator: URLValidating = URLValidator()) {
        self.modelContext = modelContext
        self.urlValidator = urlValidator
    }
    
    func processSharedURL(_ urlString: String) async -> Bool {
        isProcessing = true
        defer { isProcessing = false }
        
        let validation = urlValidator.validateURL(urlString)
        
        guard validation.isValid, let platform = validation.platform else {
            errorMessage = "Only TikTok, Instagram Reels, and YouTube Shorts are supported"
            return false
        }
        
        return await saveLink(url: urlString, platform: platform)
    }
    
    private func saveLink(url: String, platform: LinkPlatform) async -> Bool {
        do {
            let item = Item(url: url, platform: platform)
            modelContext.insert(item)
            try modelContext.save()
            return true
        } catch {
            errorMessage = "Failed to save link: \(error.localizedDescription)"
            return false
        }
    }
}

