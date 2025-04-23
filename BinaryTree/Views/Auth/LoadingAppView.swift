//
//  LoadingAppView.swift
//  FamilyTree
//
//  Created by Alex Smithson on 4/16/25.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftData
import SwiftUI

struct LoadingAppView: View {

    @Environment(\.modelContext) private var modelContext

    @ObservedObject private var viewModel: LoadingAppViewModel

    init(user: User) {
        self.viewModel = LoadingAppViewModel(user: user)
    }

    var body: some View {
        VStack(spacing: 16) {
            loginSuccessMessage()
            loadingAppDataMessage()
        }
        .onAppear {
            Task { @MainActor in
                await viewModel.loadAppData(modelContext)
            }
        }
        .fullScreenCover(isPresented: $viewModel.proceedToApp) {
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

    @ViewBuilder
    func loadingAppDataMessage() -> some View {
        Text("🔄 Loading Your Family Tree ...")
            .foregroundColor(.gray)
            .font(.subheadline)
            .transition(.opacity)
    }
}
