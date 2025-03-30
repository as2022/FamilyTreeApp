//
//  FamilyTreeView.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/15/25.
//

import SwiftData
import SwiftUI

struct FamilyTreeView: View {

    @Environment(\.modelContext) private var modelContext
    @Query private var allMembers: [FamilyMember]
    @State private var tree: FamilyMember = FamilyMember(firstName: "Loading", lastName: "Tree")

    var body: some View {
        VStack {
            Text("Family Tree")
                .font(.headline)
                .onAppear {
                    if let member = allMembers.first {
                        tree = member
                    } else {
                        let newPerson = FamilyMember(firstName: "Root", lastName: "Node")
                        modelContext.insert(newPerson)
                        tree = newPerson
                    }
                }
            if allMembers.isEmpty {
                Text("Welcome to the Family Tree App!")
                    .font(.headline)
                Text("Click the 'Add' button to start building your family tree.")
                    .font(.caption)
            }
            ScrollView([.vertical, .horizontal]) {
                Diagram(tree: $tree, node: { node in
                    FamilyMemberView(member: node.wrappedValue, onDelete: { member in
                        tree.delete(person: member)
                    })
                })
            }
        }
    }
}
