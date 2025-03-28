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
    @State private var tree: Tree<Unique<FamilyMember>> = Tree(Unique(FamilyMember(firstName: "", lastName: "", birthDate: Date(), birthPlace: "")), children: [])

    var body: some View {
        VStack {
            Text("Family Tree")
                .font(.headline)
            Button("Reload") {
                if let firstMember = allMembers.first {
                    tree = Tree(Unique(firstMember))
                }
            }
            Spacer()
            Diagram(tree: $tree, node: { subTree in
                FamilyMemberView(member: subTree.wrappedValue.value.value) {
                    subTree.wrappedValue.add(child: FamilyMember(firstName: "", lastName: "", birthDate: Date(), birthPlace: ""))
                    modelContext.insert(subTree.wrappedValue.value.value)
                }
            })
        }
    }
}
