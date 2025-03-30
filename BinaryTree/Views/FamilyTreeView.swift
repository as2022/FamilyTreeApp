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
    @State private var tree: Tree<Unique<FamilyMember>> = Tree(Unique(FamilyMember(firstName: "Ralph", lastName: "Smith", sex: .male ,birthDate: Date(), birthPlace: "Iowa")), children: [])

    var body: some View {
        if allMembers.isEmpty {
            VStack {
                Text("Welcome to the Family Tree App!")
                    .font(.headline)
                Text("Click the 'Add' button to start building your family tree.")
                    .font(.caption)
            }
        }
        Diagram(tree: $tree, node: { node in
            FamilyMemberView(member: node.wrappedValue.value.value, onChildAdd: { newChild in
                node.wrappedValue.insert(child: newChild, for: node.wrappedValue.value.value)
            }, onSpouseAdd: { newSpouse in
                node.wrappedValue.insert(spouse: newSpouse, for: node.wrappedValue.value.value)
            })
        })
    }
}
