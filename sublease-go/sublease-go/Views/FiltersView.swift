//
//  FiltersView.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/3/26.
//

import SwiftUI

struct FiltersView: View {
    @Binding var filters: Filters
    @Environment(\.dismiss) private var dismiss
    @State private var maxPriceText: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Basics") {
                    Stepper("Min bedrooms: \(filters.minBedrooms ?? 0)", value: Binding(
                        get: { filters.minBedrooms ?? 0 },
                        set: { filters.minBedrooms = ($0 == 0 ? nil : $0) }
                    ), in: 0...10)

                    TextField("Max price", text: Binding(
                        get: { filters.maxPrice.map(String.init) ?? maxPriceText },
                        set: { maxPriceText = $0; filters.maxPrice = Int($0) }
                    ))
                    .keyboardType(.numberPad)

                    Toggle("Furnished only", isOn: $filters.furnishedOnly)
                }

                Section {
                    Button("Clear all") { filters = Filters() }
                        .foregroundStyle(.red)
                }
            }
            .navigationTitle("Filters")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button("Close") { dismiss() } }
            }
        }
    }
}
