//
//  BinaryTreeApp.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/15/25.
//

import SwiftUI
import SwiftData

@main
struct BinaryTreeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: FamilyMember.self)
        }
    }
}
