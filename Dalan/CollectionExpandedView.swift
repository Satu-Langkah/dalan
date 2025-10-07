//
//  CollectionExpanded.swift
//  Dalan
//
//  Created by Jerry Febriano on 08/10/25.
//

import SwiftUI

struct CollectionExpanded: View {
    let categories: [(String, Int)] = [
        ("🍛 Food & Beverages", 24),
        ("🍃 Nature", 12),
        ("🎉 Night life", 11),
        ("📸 Photo Spots", 11),
        ("💪 Sports & Arenas", 10),
        ("🕶️ Jakarta", 8),
        ("🛍 Shopping Corners", 6),
        ("🕶️ UMKM", 4),
        ("🕶️ Hidden Gem", 2),
        ("🏰 Historical", 2),
        ("🗽 Landmarks & Attractions", 2),
        ("🎶 Music & Festivals", 0),
    ]

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("Your Personal Interest Collection")
                        .font(.title)
                        .fontWeight(.semibold)
                        .kerning(-0.1)
                        .foregroundColor(
                            Color(red: 0.22, green: 0.29, blue: 0.34)
                        )
                        .background(alignment: .topTrailing) {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(
                                    Color(red: 1, green: 0.89, blue: 0.29)
                                )
                                .offset(x: -45, y: -4)
                        }

                    Spacer()
                }

                HStack(alignment: .firstTextBaseline, spacing: 24) {
                    HStack(alignment: .firstTextBaseline, spacing: 5) {
                        Text("120")
                            .font(.system(size: 48, weight: .semibold))
                            .foregroundColor(
                                Color(red: 0.22, green: 0.29, blue: 0.34)
                            )

                        Text("Insight")
                            .font(.callout)
                            .fontWeight(.regular)
                            .foregroundColor(
                                Color(red: 0.22, green: 0.29, blue: 0.34)
                            )
                    }

                    HStack(alignment: .firstTextBaseline, spacing: 10) {
                        Text("100")
                            .font(.system(size: 48, weight: .semibold))
                            .foregroundColor(
                                Color(red: 0.22, green: 0.29, blue: 0.34)
                            )

                        Text("Places to go")
                            .font(.callout)
                            .fontWeight(.regular)
                            .foregroundColor(
                                Color(red: 0.22, green: 0.29, blue: 0.34)
                            )
                    }
                }
                .kerning(-0.2)
                .padding(.all, 0)

                FlowLayout(spacing: 10) {
                    ForEach(categories, id: \.0) { name, count in
                        CapsuleView(name, count)
                    }
                }

            }
            .padding(.horizontal, 24)
        }
        .background {
            ZStack {
                Color(red: 0.973, green: 0.973, blue: 0.973)
                Image("gradient").ignoresSafeArea()
            }
        }
    }
}

#Preview {
    CollectionExpanded()
}

