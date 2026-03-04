//
//  ChatThreadView.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/3/26.
//

import SwiftUI

struct ChatThreadView: View {
    let threadId: String
    @Binding var threads: [Thread]
    @State private var draft = ""

    private var threadIndex: Int? { threads.firstIndex(where: { $0.id == threadId }) }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    if let idx = threadIndex {
                        ForEach(threads[idx].messages) { message in
                            HStack {
                                if (message.isMe) {
                                    Spacer()
                                }
                                Text(message.body)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 10)
                                    .background(message.isMe ? Color.black : Color.black.opacity(0.08))
                                    .foregroundStyle(message.isMe ? .white : .primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                if (!message.isMe) {
                                    Spacer()
                                }
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
                    guard !text.isEmpty, let idx = threadIndex else { return }
                    draft = ""
                    let msg = Message(id: UUID().uuidString, body: text, isMe: true, sentAt: Date())
                    threads[idx].messages.append(msg)
                    threads[idx].lastPreview = text
                    threads[idx].updatedAt = Date()
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
    }
}
