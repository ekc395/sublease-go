//
//  ListingDetailView.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/3/26.
//

import SwiftUI

struct ListingDetailView: View {
    let listing: Listing
    let currentUserId: String
    let currentUserName: String
    @Binding var threads: [Thread]

    @Environment(\.dismiss) private var dismiss
    @State private var pushToThread: Thread? = nil

    private let messagingService = FirebaseMessagingService()

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
                            Pill(listing.apartmentBuilding)
                        }

                        Text(listing.description)
                    }
                    .card()

                    Button {
                        Task {
                            do {
                                let threadId = try await messagingService.createOrGetThread(
                                    listingId: listing.id,
                                    listingTitle: listing.title,
                                    currentUserId: currentUserId,
                                    currentUserName: currentUserName,
                                    otherUserId: listing.userId,
                                    otherUserName: listing.ownerName
                                )

                                await MainActor.run {
                                    if let existing = threads.first(where: { $0.id == threadId }) {
                                        pushToThread = existing
                                    } else {
                                        let new = Thread(
                                            id: threadId,
                                            listingId: listing.id,
                                            otherName: listing.ownerName,
                                            lastPreview: "",
                                            updatedAt: Date(),
                                            messages: []
                                        )
                                        threads.insert(new, at: 0)
                                        pushToThread = new
                                    }
                                }
                            } catch {
                                print("Failed to create/get thread:", error.localizedDescription)
                            }
                        }
                    } label: {
                        Text("Message lister")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.black)
                }
                .padding(16)
            }
            .navigationTitle("Listing")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
            .navigationDestination(item: $pushToThread) { thread in
                ChatThreadView(
                    threadId: thread.id,
                    currentUserId: currentUserId,
                    threads: $threads
                )
            }
        }
    }
}
