//
//  Thread.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/3/26.
//


import Foundation

struct Thread: Identifiable, Hashable {
    let id: String
    let listingId: String
    var otherName: String
    var lastPreview: String
    var updatedAt: Date
    var messages: [Message]

    static let mock: [Thread] = [
        .init(id: "T1", listingId: "L1", otherName: "Joseph", lastPreview: "Still available?", updatedAt: Date(), messages: [
            .init(id: "M1", body: "Hi! Is this still available?", isMe: false, sentAt: Date())
        ])
    ]
}

struct Message: Identifiable, Hashable {
    let id: String
    let body: String
    let isMe: Bool
    let sentAt: Date
}
