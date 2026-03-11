//
//  MessagesView.swift
//  sublease-go
//
//  Created by Hanna Pan on 3/3/26.
//

import SwiftUI

struct MessagesView: View {
    let currentUserId: String
    @Binding var threads: [Thread]
    
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
                
                VStack(spacing: 0) {
                    Text("Messages")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(uwPurple)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    List {
                        ForEach(threads) { thread in
                            NavigationLink(value: thread.id) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(thread.otherName)
                                        .font(.headline)
                                        .foregroundStyle(textPrimary)

                                    Text(thread.lastPreview)
                                        .foregroundStyle(textMuted)
                                        .lineLimit(1)
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
                .padding(.top, 20)
            }
            .navigationDestination(for: String.self) { threadId in
                ChatThreadView(
                    threadId: threadId,
                    currentUserId: currentUserId,
                    threads: $threads
                )
            }
        }
    }
}
