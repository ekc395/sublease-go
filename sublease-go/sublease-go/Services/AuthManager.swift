//
//  AuthManager.swift
//  sublease-go
//
//  Created by Ethan Chen on 3/5/26.
//

import Combine
import Foundation
import SwiftUI

final class AuthManager: ObservableObject {
    static let shared = AuthManager()

    private let emailKey = "subleaseGo.uwEmail"

    @Published private(set) var uwEmail: String = ""
    @Published private(set) var isAuthed: Bool = false

    init() {
        restore()
    }

    func restore() {
        let saved = UserDefaults.standard.string(forKey: emailKey)?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if let email = saved, email.hasSuffix("@uw.edu") {
            uwEmail = email
            isAuthed = true
        } else {
            uwEmail = ""
            isAuthed = false
        }
    }

    func login(email: String) {
        let normalized = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard normalized.hasSuffix("@uw.edu") else { return }
        uwEmail = normalized
        isAuthed = true
        UserDefaults.standard.set(normalized, forKey: emailKey)
    }

    func signOut() {
        uwEmail = ""
        isAuthed = false
        UserDefaults.standard.removeObject(forKey: emailKey)
    }
}
