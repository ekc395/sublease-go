//
//  CreateListingView.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/3/26.
//

import SwiftUI

struct CreateListingView: View {
    @Binding var listings: [Listing]

    @State private var title = ""
    @State private var description = ""
    @State private var price = ""
    @State private var bedrooms = 1
    @State private var neighborhood = ""
    @State private var furnished = false
    @State private var error: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Listing") {
                    TextField("Title", text: $title)
                    TextField("Neighborhood", text: $neighborhood)
                    TextField("Monthly price", text: $price)
                        .keyboardType(.numberPad)
                    Stepper("Bedrooms: \(bedrooms)", value: $bedrooms, in: 1...10)
                    Toggle("Furnished", isOn: $furnished)
                }

                Section("Description") {
                    TextEditor(text: $description)
                        .frame(minHeight: 120)
                }

                Section {
                    Button {
                        guard let p = Int(price), p > 0 else { error = "Enter a valid price."; return }
                        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { error = "Title is required."; return }
                        error = nil

                        let new = Listing(
                            id: UUID().uuidString,
                            title: title,
                            price: p,
                            bedrooms: bedrooms,
                            neighborhood: neighborhood.isEmpty ? "Seattle" : neighborhood,
                            furnished: furnished,
                            description: description.isEmpty ? "No description yet." : description
                        )
                        listings.insert(new, at: 0)
                        title = ""; description = ""; price = ""; bedrooms = 1; neighborhood = ""; furnished = false
                    } label: {
                        Text("Post listing").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.black)
                }

                if let error {
                    Section { Text(error).foregroundStyle(.red) }
                }
            }
            .navigationTitle("Create")
        }
    }
}
