//
//  BinaryTreeApp.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/15/25.
//

import Firebase
import SwiftData
import SwiftUI

@main
struct BinaryTreeApp: App {

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            AuthView()
        }
        .modelContainer(for: [FamilyMember.self, CrossBloodLineConnection.self])
    }
}
