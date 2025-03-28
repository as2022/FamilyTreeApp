//
//  ContentView.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/15/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            ScrollView([.vertical, .horizontal]) {
                FamilyTreeView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        do {
                            try modelContext.save()
                        } catch {
                            print("Failed to save context: \(error)")
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
