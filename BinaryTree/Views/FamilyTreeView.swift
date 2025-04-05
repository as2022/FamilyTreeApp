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
    @State private var trees = [FamilyMember]()
//    @State private var tree: FamilyMember = FamilyMember(firstName: "Loading", lastName: "Tree")


    var body: some View {
        VStack {
            Text("Family Tree")
                .font(.headline)
                .onAppear {
                    let roots = allMembers.filter({ $0.isTopOfBloodline })
                    if roots.isEmpty {
                        allMembers.forEach {
                            modelContext.delete($0)
                        }
                        let newPerson = FamilyMember(firstName: "Root", lastName: "Node")
                        newPerson.isTopOfBloodline = true
                        modelContext.insert(newPerson)
//                        tree = newPerson
                        trees.append(newPerson)
                    } else {
//                        tree = roots[0]
                        trees = roots

                    }
                }
            if allMembers.isEmpty {
                Text("Welcome to the Family Tree App!")
                    .font(.headline)
                Text("Click the 'Add' button to start building your family tree.")
                    .font(.caption)
            }
            ScrollView([.vertical, .horizontal]) {
                HStack {
                    ForEach($trees.wrappedValue, id: \.id) { tree in
                        Diagram(
                            root: Binding(
                                get: { tree },
                                set: { newTree in
                                    let index = trees.firstIndex(where: { $0.id == tree.id })
                                    if let index = index {
                                        trees[index] = newTree
                                    }
                                }
                            ),
                            node: { node in
                                FamilyMemberView(
                                    member: node.wrappedValue,
                                    onDelete: { member in
                                        if member == node.wrappedValue {
                                            modelContext.delete(member)
                                            trees.removeAll { $0.id == member.id }
                                        } else {
                                            tree.delete(person: member)
                                        }
                                    }
                                )
                            },
                            newRoot: { newRoot in
                                newRoot.isTopOfBloodline = true
                                tree.isTopOfBloodline = false
//                                trees = newRoot
                            },
                            newBloodline: { newBloodline in
                                newBloodline.isTopOfBloodline = true
                                trees.append(newBloodline)
                            }
                        )
                    }
                }
            }
        }
    }
}
