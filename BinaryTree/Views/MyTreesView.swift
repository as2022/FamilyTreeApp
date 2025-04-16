//
//  MyTreesView.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/15/25.
//

import SwiftData
import SwiftUI

struct MyTreesView: View {

    @Environment(\.modelContext) private var modelContext

    @Query private var allMembers: [FamilyMember]
    @Query private var allCrossBloodlineConnections: [CrossBloodlineConnection]

    @State private var trees = [FamilyMember]()
    @State private var crossBloodlineConnections = [CrossBloodlineConnection]()
    @State private var draggingFromMember: FamilyMember?
    @State private var personDetailsToPresent: FamilyMember?

    var body: some View {
        TreeHUDView(
            manualConnectionMember: $draggingFromMember,
            personDetailsToPresent: $personDetailsToPresent
        ) {
            HStack(alignment: .top, spacing: 50) {
                ForEach($trees.sorted(by: { $0.wrappedValue.familySize > $1.wrappedValue.familySize })) { $tree in
                    makeTree(for: $tree)
                }
            }
            .drawConnections(for: $crossBloodlineConnections)
        }
        .onAppear {
            // People
            let roots = allMembers.filter({ $0.isTopOfBloodline })
            if roots.isEmpty {
                let newPerson = createInitialFamily()
                modelContext.insert(newPerson)
                trees.append(newPerson)
            } else {
                trees = roots
                crossBloodlineConnections = allCrossBloodlineConnections
            }
        }
    }

    // MARK: - ViewBuilders

    @ViewBuilder
    func makeTree(for tree: Binding<FamilyMember>) -> some View {
        ZStack {
            VStack(alignment: .center, spacing: 20) {
                Text("\(tree.wrappedValue.lastName ?? tree.wrappedValue.firstName ?? "My") Family")
                Diagram(
                    root: tree,
                    node: { node in
                        FamilyMemberView(
                            member: node.wrappedValue,
                            onDelete: { member, needsHelpDeletingSpousalReference in
                                if needsHelpDeletingSpousalReference {
                                    tree.wrappedValue.delete(spouse: member)
                                } else {
                                    tree.wrappedValue.delete(member)
                                }
                                removeReferencesToMember(member)
                            },
                            newRoot: { newRoot in
                                tree.wrappedValue = newRoot
                            },
                            newBloodline: { child, parent in
                                trees.append(parent)
                                
                                // Capture the connection from the current root (the child)
                                // to the new bloodline root (the parent)
                                let newConnection = CrossBloodlineConnection(fromChild: child.id, toNewParent: parent.id)
                                crossBloodlineConnections.append(newConnection)
                                modelContext.insert(newConnection)
                            },
                            outlineColor: provideOutlineColor(for: node.wrappedValue)
                        )
                        // Tap gesture — only fire if long press didn’t happen
                        .onTapGesture {
                            personDetailsToPresent = node.wrappedValue
                        }

                        // Long press gesture sets the flag
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.5)
                                .onEnded { _ in
                                    if let fromPerson = draggingFromMember {
                                        let toID = node.wrappedValue.id
                                        if fromPerson.id != toID {
                                            let newConnection = CrossBloodlineConnection(fromChild: fromPerson.id, toNewParent: toID)
                                            crossBloodlineConnections.append(newConnection)
                                            modelContext.insert(newConnection)
                                        }
                                        draggingFromMember = nil
                                    } else {
                                        draggingFromMember = node.wrappedValue
                                    }
                                }
                        )
                    }
                )
            }
            .padding( 20)
        }
        .background(ColorTheme.lightGray.opacity(0.3))
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
        .overlay(
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                .strokeBorder(ColorTheme.lightGray, lineWidth: 1)
        )

    }

    // MARK: - Helper Functions

    private func removeReferencesToMember(_ member: FamilyMember) {
        crossBloodlineConnections.removeAll(where: { connection in
            if connection.fromChild == member.id || connection.toNewParent == member.id {
                modelContext.delete(connection)
                return true
            } else {
                return false
            }
        })

        // Delete Entire Family if is the last one
        if member.isTopOfBloodline, member.familySize == 1, let index = trees.firstIndex(of: member) {
            trees.remove(at: index)
        }
        modelContext.delete(member)
    }

    private func provideOutlineColor(for person: FamilyMember) -> Color {
        if let indexOfConnection = crossBloodlineConnections
            .firstIndex(where: { $0.fromChild == person.id || $0.toNewParent == person.id })
        {
            return ConnectionColor.allCases[indexOfConnection].color
        } else {
            return .clear
        }
    }

    private func createInitialFamily() -> FamilyMember {
        let grandpa = FamilyMember(firstName: "Grandpa", sex: .male, isTopOfBloodline: true)
        let mom = FamilyMember(firstName: "Mom", sex: .female, isMarriedIntoFamily: true)
        let dad = FamilyMember(firstName: "Dad", sex: .male, spouse: mom)
        dad.children.append(FamilyMember(firstName: "Me"))
        grandpa.children.append(dad)
        return grandpa
    }
}

