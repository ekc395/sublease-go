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
    
    private let uwPurple = Color(red: 0.227, green: 0.114, blue: 0.514)
    private let uwGold = Color(red: 0.929, green: 0.710, blue: 0.102)
    private let background = Color(red: 0.969, green: 0.965, blue: 0.980)
    private let textPrimary = Color(red: 0.122, green: 0.082, blue: 0.216)
    private let textMuted = Color(red: 0.451, green: 0.400, blue: 0.557)
    private let textBox = Color(red: 0.938, green: 0.928, blue: 0.973)

    var body: some View {
        NavigationStack {
            ZStack {
                background.ignoresSafeArea()
                Form {
                    Text("Filters")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(uwPurple)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .listRowBackground(Color.clear)
                    
                    Section {
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
                        Button("Clear all") {
                            filters = Filters()
                        }
                        .foregroundStyle(.red)
                    }
                }
                .foregroundStyle(textPrimary)
                .scrollContentBackground(.hidden)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}
