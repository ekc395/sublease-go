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
}

struct Message: Identifiable, Hashable {
    let id: String
    let body: String
    let isMe: Bool
    let sentAt: Date
}
