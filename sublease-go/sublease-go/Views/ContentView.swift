//
//  ContentView.swift
//  sublease-go
//
//  Created by Ethan Chen on 3/3/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var auth: AuthManager

    @State private var listings: [Listing] = []
    @State private var filters = Filters()
    @State private var threads: [Thread] = Thread.mock

    var body: some View {
        Group {
            if auth.isAuthed {
                MainTabView(
                    uwEmail: auth.uwEmail,
                    listings: $listings,
                    filters: $filters,
                    threads: $threads
                )
            } else {
                LoginView()
            }
        }
        .tint(.black)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthManager.shared)
}
