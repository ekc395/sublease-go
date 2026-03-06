//
//  Listing.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/3/26.
//

import Foundation

struct Listing: Identifiable, Hashable {
    let id: String
    var title: String
    var price: Int
    var bedrooms: Int
    var apartmentBuilding: String
    var furnished: Bool
    var description: String
    var genderPreference: String
    var leaseStart: Date
    var leaseEnd: Date
    var schoolYearPreference: String
    var userId: String

    static let mock: [Listing] = [
        .init(id: "L1", title: "Room Available in 2BR Apartment in U-District (Savannah Apartments)", price: 1250, bedrooms: 1, apartmentBuilding: "Savannah Apartments", furnished: true, description: "Bright unit, quiet building, laundry in building.", genderPreference: "Any", leaseStart: Date(), leaseEnd: Date().addingTimeInterval(90*24*3600), schoolYearPreference: "Any", userId: ""),
        .init(id: "L2", title: "2BR apartment at The Twelve", price: 980, bedrooms: 2, apartmentBuilding: "The Twelve", furnished: false, description: "Spacious 2BR with great natural light. Easy bus access to campus.", genderPreference: "Any", leaseStart: Date(), leaseEnd: Date().addingTimeInterval(90*24*3600), schoolYearPreference: "Any", userId: "")
    ]
}

struct Filters: Hashable {
    var minBedrooms: Int? = nil
    var maxPrice: Int? = nil
    var furnishedOnly: Bool = false

    func apply(to listings: [Listing]) -> [Listing] {
        listings.filter { l in
            if let minBedrooms, l.bedrooms < minBedrooms {
                return false
            }
            if let maxPrice, l.price > maxPrice {
                return false
            }
            if furnishedOnly, l.furnished == false {
                return false
            }
            return true
        }
    }
}
