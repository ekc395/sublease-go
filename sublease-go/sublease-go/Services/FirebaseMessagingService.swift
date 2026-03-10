//
//  FirebaseMessagingService.swift
//  sublease-go
//
//  Created by Joseph Tran on 3/9/26.
//

import Foundation
import FirebaseFirestore

final class FirebaseMessagingService {
    private let db = Firestore.firestore()

    func listenForThreads(
        currentUserId: String,
        onChange: @escaping ([Thread]) -> Void
    ) -> ListenerRegistration {
        db.collection("threads")
            .whereField("participantIds", arrayContains: currentUserId)
            .order(by: "lastMessageAt", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let docs = snapshot?.documents else {
                    print("Failed to load threads:", error?.localizedDescription ?? "unknown error")
                    return
                }

                let threads: [Thread] = docs.map { doc in
                    let data = doc.data()
                    let listingId = data["listingId"] as? String ?? ""
                    let lastPreview = data["lastMessageText"] as? String ?? ""
                    let ts = data["lastMessageAt"] as? Timestamp ?? Timestamp(date: Date())

                    let names = data["participantNames"] as? [String: String] ?? [:]
                    let otherName = names.first(where: { $0.key != currentUserId })?.value ?? "User"

                    return Thread(
                        id: doc.documentID,
                        listingId: listingId,
                        otherName: otherName,
                        lastPreview: lastPreview,
                        updatedAt: ts.dateValue(),
                        messages: []
                    )
                }

                onChange(threads)
            }
    }

    func listenForMessages(
        threadId: String,
        currentUserId: String,
        onChange: @escaping ([Message]) -> Void
    ) -> ListenerRegistration {
        db.collection("threads")
            .document(threadId)
            .collection("messages")
            .order(by: "createdAt", descending: false)
            .addSnapshotListener { snapshot, error in
                guard let docs = snapshot?.documents else {
                    print("Failed to load messages:", error?.localizedDescription ?? "unknown error")
                    return
                }

                let messages: [Message] = docs.map { doc in
                    let data = doc.data()
                    let senderId = data["senderId"] as? String ?? ""
                    let text = data["text"] as? String ?? ""
                    let ts = data["createdAt"] as? Timestamp ?? Timestamp(date: Date())

                    return Message(
                        id: doc.documentID,
                        body: text,
                        isMe: senderId == currentUserId,
                        sentAt: ts.dateValue()
                    )
                }

                onChange(messages)
            }
    }

    func sendMessage(threadId: String, body: String, senderId: String) async throws {
        let trimmed = body.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let messageData: [String: Any] = [
            "senderId": senderId,
            "text": trimmed,
            "createdAt": Timestamp(date: Date())
        ]

        try await db.collection("threads")
            .document(threadId)
            .collection("messages")
            .addDocument(data: messageData)

        try await db.collection("threads")
            .document(threadId)
            .updateData([
                "lastMessageText": trimmed,
                "lastMessageAt": Timestamp(date: Date()),
                "lastSenderId": senderId
            ])
    }

    func createOrGetThread(
        listingId: String,
        listingTitle: String,
        currentUserId: String,
        currentUserName: String,
        otherUserId: String,
        otherUserName: String
    ) async throws -> String {
        let participantIds = [currentUserId, otherUserId].sorted()

        let snapshot = try await db.collection("threads")
            .whereField("listingId", isEqualTo: listingId)
            .whereField("participantIds", isEqualTo: participantIds)
            .getDocuments()

        if let existing = snapshot.documents.first {
            return existing.documentID
        }

        let now = Timestamp(date: Date())

        let threadData: [String: Any] = [
            "listingId": listingId,
            "listingTitle": listingTitle,
            "participantIds": participantIds,
            "participantNames": [
                currentUserId: currentUserName,
                otherUserId: otherUserName
            ],
            "lastMessageText": "",
            "lastMessageAt": now,
            "lastSenderId": "",
            "createdAt": now
        ]

        let ref = try await db.collection("threads").addDocument(data: threadData)
        return ref.documentID
    }
}
