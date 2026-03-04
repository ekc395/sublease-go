//
//  ProfileView.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/3/26.
//

// more information needed for profile page
import SwiftUI

struct ProfileView: View {
    let uwEmail: String
    let listings: [Listing]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("UW Verified").font(.headline)
                        Text(uwEmail).foregroundStyle(.secondary)
                    }
                    .card()

                    VStack(alignment: .leading, spacing: 8) {
                        Text("My Listings").font(.headline)
                        if listings.isEmpty {
                            Text("No listings yet.").foregroundStyle(.secondary)
                        } else {
                            ForEach(listings.prefix(3)) { ListingCard(listing: $0) }
                        }
                    }
                    .card()
                }
                .padding(16)
            }
            .navigationTitle("Profile")
        }
    }
}
