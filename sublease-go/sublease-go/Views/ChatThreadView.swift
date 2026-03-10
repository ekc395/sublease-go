//
//  ChatThreadView.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/3/26.
//

import SwiftUI
import FirebaseFirestore

struct ChatThreadView: View {
    let threadId: String
    let currentUserId: String
    @Binding var threads: [Thread]

    @State private var draft = ""
    @State private var liveMessages: [Message] = []
    @State private var listener: ListenerRegistration?

    private let messagingService = FirebaseMessagingService()

    private var threadIndex: Int? {
        threads.firstIndex(where: { $0.id == threadId })
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(liveMessages) { message in
                        HStack {
                            if message.isMe {
                                Spacer()
                            }

                            Text(message.body)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .background(message.isMe ? Color.black : Color.black.opacity(0.08))
                                .foregroundStyle(message.isMe ? .white : .primary)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                            if !message.isMe {
                                Spacer()
                            }
                        }
                    }
                }
                .padding(16)
            }

            Divider()

            HStack(spacing: 10) {
                TextField("Message…", text: $draft, axis: .vertical)
                    .textFieldStyle(.roundedBorder)

                Button {
                    let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !text.isEmpty else { return }
                    draft = ""

                    Task {
                        do {
                            try await messagingService.sendMessage(
                                threadId: threadId,
                                body: text,
                                senderId: currentUserId
                            )
                        } catch {
                            print("Failed to send message:", error.localizedDescription)
                        }
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                }
                .padding(.horizontal, 6)
            }
            .padding(12)
            .background(Color(.secondarySystemBackground))
        }
        .navigationTitle(threads.first(where: { $0.id == threadId })?.otherName ?? "Chat")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            listener = messagingService.listenForMessages(
                threadId: threadId,
                currentUserId: currentUserId
            ) { messages in
                self.liveMessages = messages

                if let idx = threadIndex, let last = messages.last {
                    threads[idx].lastPreview = last.body
                    threads[idx].updatedAt = last.sentAt
                    threads[idx].messages = messages
                }
            }
        }
        .onDisappear {
            listener?.remove()
            listener = nil
        }
    }
}
