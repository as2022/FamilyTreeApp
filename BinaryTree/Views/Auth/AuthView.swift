//
//  AuthView.swift
//  BinaryTree
//
//  Created by Alex Smithson on 4/13/25.
//

import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()

    @State private var email = ""
    @State private var password = ""
    @State private var isCreatingAccount = false

    var body: some View {
        VStack(spacing: 16) {
            if viewModel.showSuccessMessage {
                loginSuccessMessage()
            } else {
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                // 🔴 Error message (if any)
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button(isCreatingAccount ? "Sign Up" : "Log In") {
                    Task {
                        if isCreatingAccount {
                            await viewModel.signUp(email: email, password: password)
                        } else {
                            await viewModel.signIn(email: email, password: password)
                        }
                        viewModel.checkAuthAndProceed()
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Button(isCreatingAccount ? "Already have an account? Log In" : "Don't have an account? Sign Up") {
                    isCreatingAccount.toggle()
                }
                .font(.footnote)
                .padding()
            }
        }
        .onAppear {
            viewModel.checkAuthAndProceed()
        }
        .fullScreenCover(isPresented: $viewModel.proceedToTree) {
            ContentView()
        }
    }

    // MARK: - ViewBuilders

    @ViewBuilder
    func loginSuccessMessage() -> some View {
        Text("✅ Logged in!")
            .foregroundColor(.green)
            .font(.subheadline)
            .transition(.opacity)
    }
}
