//
//  MainTabView.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/3/26.
//

import SwiftUI

struct MainTabView: View {
    let uwEmail: String
    @Binding var listings: [Listing]
    @Binding var filters: Filters
    @Binding var threads: [Thread]

    var body: some View {
        TabView {
            ListingFeedView(listings: $listings, filters: $filters, threads: $threads)
                .tabItem {
                    Label("Feed", systemImage: "square.grid.2x2")
                }

            CreateListingView(listings: $listings)
                .tabItem {
                    Label("Post", systemImage: "plus.circle")
                }

            MessagesView(threads: $threads)
                .tabItem {
                    Label("Messages", systemImage: "message")
                }

            ProfileView(uwEmail: uwEmail, listings: listings)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}
