//
//  AuthViewModel.swift
//  BinaryTree
//
//  Created by Alex Smithson on 4/13/25.
//

import Foundation
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {

    @Published var user: User?
    @Published var errorMessage: String?
    @Published var showSuccessMessage = false
    @Published var proceedToTree = false

    init() {
        self.user = Auth.auth().currentUser
        print("current user: \(user?.email ?? "anonymous")")
    }

    func signIn(email: String, password: String) async {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.user = result.user
            errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func signUp(email: String, password: String) async {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.user = result.user
            errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
        self.user = nil
    }

    func checkAuthAndProceed() {
        if user != nil {
            showSuccessMessage = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.proceedToTree = true
            }
        }
    }
}
