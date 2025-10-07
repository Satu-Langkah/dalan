//
//  ContentView.swift
//  Dalan
//
//  Created by Jerry Febriano on 29/09/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Item.timestamp, order: .reverse) private var items: [Item]

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    LinkItemRow(item: item)
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Saved Links")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .overlay {
                if items.isEmpty {
                    EmptyStateView()
                }
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

struct LinkItemRow: View {
    let item: Item
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                PlatformIcon(platform: item.platformEnum)
                
                Text(item.platformEnum.rawValue)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(item.timestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Text(item.url)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(.vertical, 4)
    }
}

struct PlatformIcon: View {
    let platform: LinkPlatform
    
    var body: some View {
        Image(systemName: iconName)
            .foregroundStyle(iconColor)
            .frame(width: 24, height: 24)
    }
    
    private var iconName: String {
        switch platform {
        case .tiktok:
            return "music.note"
        case .instagram:
            return "camera.fill"
        case .youtubeShorts:
            return "play.rectangle.fill"
        case .unknown:
            return "link"
        }
    }
    
    private var iconColor: Color {
        switch platform {
        case .tiktok:
            return .pink
        case .instagram:
            return .purple
        case .youtubeShorts:
            return .red
        case .unknown:
            return .gray
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "link.circle")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)
            
            Text("No saved links")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("Share TikTok, Instagram Reels, or YouTube Shorts to save them here")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

#Preview("Mock Data") {
    // Create an in-memory container for previews
    let container = try! ModelContainer(
        for: Item.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let context = ModelContext(container)

    // Seed some mock items
    let samples: [Item] = [
        Item(
            url: "https://www.tiktok.com/@creator/video/1234567890",
            platform: .tiktok,
            timestamp: .now
        ),
        Item(
            url: "https://www.instagram.com/reel/ABCDEFG/",
            platform: .instagram,
            timestamp: .now.addingTimeInterval(-3600)
        ),
        Item(
            url: "https://www.youtube.com/shorts/HijklMnOp",
            platform: .youtubeShorts,
            timestamp: .now.addingTimeInterval(-86400)
        )
    ]

    for item in samples { context.insert(item) }
    try? context.save()

    return ContentView()
        .modelContainer(container)
}
