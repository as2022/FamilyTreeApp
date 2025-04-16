//
//  BinaryTreeApp.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/15/25.
//

import Firebase
import FirebaseAuth
import SwiftData
import SwiftUI

@main
struct FamilyTreeApp: App {
    let container: ModelContainer

    init() {
        FirebaseApp.configure()

        let schema = Schema([
            FamilyMember.self,
            CrossBloodlineConnection.self
        ])
        
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        self.container = try! ModelContainer(for: schema, configurations: [configuration])
    }

    var body: some Scene {
        WindowGroup {
            if let user = Auth.auth().currentUser {
                LoadingAppView(user: user)
            } else {
                AuthView()
            }
        }
        .modelContainer(container)
    }
}
