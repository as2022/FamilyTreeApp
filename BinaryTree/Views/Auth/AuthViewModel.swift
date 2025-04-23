//
//  AuthViewModel.swift
//  FamilyTree
//
//  Created by Alex Smithson on 4/13/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftData

@MainActor
class AuthViewModel: ObservableObject {

    @Published var user: User?
    @Published var errorMessage: String?
    @Published var showSuccessMessage = false
    @Published var proceedToTree = false

    // MARK: Considering making new type called tree-graph-loader-view
    // Here are the types for it:

    var parentsInConnections: [FamilyMember] = []
    var chilrenInConnections: [FamilyMember] = []

    init() {
        self.user = Auth.auth().currentUser
        print("current user: \(user?.email ?? "anonymous")")
    }

    func signIn(email: String, password: String) async {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            proceed(user: result.user)
            errorMessage = nil
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func signUp(email: String, password: String) async {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            proceed(user: result.user)
            errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
        self.user = nil
    }

    func proceed(user: User? = Auth.auth().currentUser) {
        guard let user else { return }
        self.user = user

        showSuccessMessage = true

        // Delay and proceed after loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.proceedToTree = true
        }
    }
}

extension User: @retroactive Identifiable { }
