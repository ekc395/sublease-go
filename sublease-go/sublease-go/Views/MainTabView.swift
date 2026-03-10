//
//  MainTabView.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/3/26.
//

import SwiftUI
import FirebaseFirestore

struct MainTabView: View {
    let uwEmail: String
    @Binding var listings: [Listing]
    @Binding var filters: Filters
    @Binding var threads: [Thread]

    private let listingsService = FirebaseListingsService()
    private let messagingService = FirebaseMessagingService()

    @State private var hasLoadedListings = false
    @State private var threadListener: ListenerRegistration?

    private var currentUserId: String { uwEmail }
    private var currentUserName: String { uwEmail }

    var body: some View {
        TabView {
            ListingFeedView(
                currentUserId: currentUserId,
                currentUserName: currentUserName,
                listings: $listings,
                filters: $filters,
                threads: $threads
            )
            .tabItem {
                Label("Feed", systemImage: "square.grid.2x2")
            }

            CreateListingView(
                listings: $listings,
                userId: currentUserId,
                ownerName: currentUserName
            )
            .tabItem {
                Label("Post", systemImage: "plus.circle")
            }

            MessagesView(
                currentUserId: currentUserId,
                threads: $threads
            )
            .tabItem {
                Label("Messages", systemImage: "message")
            }

            ProfileView(uwEmail: uwEmail, listings: listings)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .task {
            await loadListingsIfNeeded()
            startThreadsListener()
        }
        .onDisappear {
            threadListener?.remove()
            threadListener = nil
        }
    }

    private func startThreadsListener() {
        threadListener?.remove()

        threadListener = messagingService.listenForThreads(currentUserId: currentUserId) { newThreads in
            self.threads = newThreads
        }
    }

    @MainActor
    private func loadListingsIfNeeded() async {
        guard !hasLoadedListings else { return }
        hasLoadedListings = true

        do {
            listings = try await listingsService.fetchListings()
        } catch {
            print("Failed to load listings from Firestore: \(error)")
        }
    }
}
