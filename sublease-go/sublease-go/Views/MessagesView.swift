//
//  MessagesView.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/3/26.
//

// note: round the messages view box a little
import SwiftUI

struct MessagesView: View {
    @Binding var threads: [Thread]

    var body: some View {
        NavigationStack {
            List {
                ForEach(threads) { t in
                    NavigationLink(value: t.id) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(t.otherName).font(.headline)
                            Text(t.lastPreview).foregroundStyle(.secondary).lineLimit(1)
                        }
                    }
                }
            }
            .navigationTitle("Messages")
            .navigationDestination(for: String.self) { threadId in
                ChatThreadView(threadId: threadId, threads: $threads)
            }
        }
    }
}
