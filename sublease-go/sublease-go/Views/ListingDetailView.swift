//
//  ListingDetailView.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/3/26.
//

import SwiftUI

struct ListingDetailView: View {
    let listing: Listing
    @Binding var threads: [Thread]
    @Environment(\.dismiss) private var dismiss
    @State private var pushToThread: Thread? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.black.opacity(0.06))
                        .frame(height: 220)
                        .overlay(Text("Photos").foregroundStyle(.secondary))

                    VStack(alignment: .leading, spacing: 10) {
                        Text(listing.title)
                            .font(.title2.weight(.semibold))

                        HStack(spacing: 8) {
                            Pill("$\(listing.price)/mo")
                            Pill("\(listing.bedrooms) BR")
                            Pill(listing.neighborhood)
                        }

                        Text(listing.description)
                    }
                    .card()

                    Button {
                        if let existing = threads.first(where: { $0.listingId == listing.id }) {
                            pushToThread = existing
                        } else {
                            let new = Thread(
                                id: UUID().uuidString,
                                listingId: listing.id,
                                otherName: "Lister",
                                lastPreview: "New thread",
                                updatedAt: Date(),
                                messages: []
                            )
                            threads.insert(new, at: 0)
                            pushToThread = new
                        }
                    } label: {
                        Text("Message lister").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.black)
                }
                .padding(16)
            }
            .navigationTitle("Listing")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button("Close") { dismiss() } }
            }
            .navigationDestination(item: $pushToThread) { thread in
                ChatThreadView(threadId: thread.id, threads: $threads)
            }
        }
    }
}
