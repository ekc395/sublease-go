//
//  CreateListingView.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/3/26.
//

import SwiftUI

struct CreateListingView: View {
    @Binding var listings: [Listing]
    var userId: String = ""

    @State private var title = ""
    @State private var description = ""
    @State private var price = ""
    @State private var bedrooms = 1
    @State private var apartmentBuilding = ""
    @State private var furnished = false
    @State private var error: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Listing") {
                    TextField("Title", text: $title)
                    TextField("Apartment / Building", text: $apartmentBuilding)
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

                        let now = Date()
                        let defaultEnd = Calendar.current.date(byAdding: .month, value: 3, to: now) ?? now
                        let new = Listing(
                            id: UUID().uuidString,
                            title: title,
                            price: p,
                            bedrooms: bedrooms,
                            apartmentBuilding: apartmentBuilding.isEmpty ? "Seattle" : apartmentBuilding,
                            furnished: furnished,
                            description: description.isEmpty ? "No description yet." : description,
                            genderPreference: "Any",
                            leaseStart: now,
                            leaseEnd: defaultEnd,
                            schoolYearPreference: "Any",
                            userId: userId
                        )
                        listings.insert(new, at: 0)
                        title = ""; description = ""; price = ""; bedrooms = 1; apartmentBuilding = ""; furnished = false
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
