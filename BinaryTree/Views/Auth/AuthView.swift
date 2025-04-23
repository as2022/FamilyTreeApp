//
//  AuthView.swift
//  FamilyTree
//
//  Created by Alex Smithson on 4/13/25.
//

import SwiftUI
import SwiftData

struct AuthView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var viewModel = AuthViewModel()
    
    @State private var email = ""
    @State private var password = ""
    @State private var isCreatingAccount = false

    var body: some View {
        VStack(spacing: 16) {
            Image(colorScheme == .dark ? "Dark Logo" : "Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding(.bottom)
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

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
                }
            }
            .buttonStyle(.borderedProminent)

            Button(isCreatingAccount ? "Already have an account? Log In" : "Don't have an account? Sign Up") {
                isCreatingAccount.toggle()
            }
            .font(.footnote)
            .padding()
        }
        .padding(24)
        .fullScreenCover(item: $viewModel.user) { user in
            LoadingAppView(user: user)
        }
    }
}

#Preview {
    let schema = Schema([FamilyMember.self, CrossBloodlineConnection.self])
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: [config])

    return AuthView()
        .modelContainer(container)
        .padding()
}

