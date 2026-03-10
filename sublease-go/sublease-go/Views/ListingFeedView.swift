//
//  ListingFeedView.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/3/26.
//

import SwiftUI

struct ListingFeedView: View {
    let currentUserId: String
    let currentUserName: String
    @Binding var listings: [Listing]
    @Binding var filters: Filters
    @Binding var threads: [Thread]

    @State private var showFilters = false
    @State private var selectedListing: Listing? = nil

    private var filteredListings: [Listing] {
        filters.apply(to: listings)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredListings) { listing in
                        ListingCard(listing: listing)
                            .onTapGesture { selectedListing = listing }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
            }
            .navigationTitle("Feed")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showFilters = true } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
            .sheet(isPresented: $showFilters) {
                FiltersView(filters: $filters)
            }
            .sheet(item: $selectedListing) { listing in
                ListingDetailView(
                    listing: listing,
                    currentUserId: currentUserId,
                    currentUserName: currentUserName,
                    threads: $threads
                )
            }
        }
    }
}
