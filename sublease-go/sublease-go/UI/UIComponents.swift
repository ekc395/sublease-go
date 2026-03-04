//
//  UIComponents.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/3/26.
//

import SwiftUI

struct Pill: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.black.opacity(0.06))
            .clipShape(Capsule())
    }
}

extension View {
    func card() -> some View {
        self
            .padding(14)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct ListingCard: View {
    let listing: Listing

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text("$\(listing.price)")
                    .font(.title3.weight(.semibold))
                Text("/mo").foregroundStyle(.secondary)
                Spacer()
                Pill("\(listing.bedrooms) BR")
            }

            Text(listing.title)
                .font(.headline)

            HStack(spacing: 8) {
                Pill(listing.neighborhood)
                Pill(listing.furnished ? "Furnished" : "Unfurnished")
            }
        }
        .card()
    }
}
