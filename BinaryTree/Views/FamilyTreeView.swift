//
//  FamilyTreeView.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/15/25.
//

import SwiftData
import SwiftUI

struct FamilyTreeView: View {

    typealias Key = CollectDict<FamilyMember.ID, Anchor<CGPoint>>

    @Environment(\.modelContext) private var modelContext

    @Query private var allMembers: [FamilyMember]
    @Query private var allCrossBloodLineConnections: [CrossBloodLineConnection]

    @State private var trees = [FamilyMember]()
    @State private var crossBloodLineConnections = [CrossBloodLineConnection]()

    var body: some View {
        VStack {
            Text("Family Tree")
                .font(.headline)
                .onAppear {
                    // People
                    let roots = allMembers.filter({ $0.isTopOfBloodline })
                    if roots.isEmpty {
                        allMembers.forEach {
                            modelContext.delete($0)
                        }
                        let newPerson = FamilyMember(firstName: "Root", lastName: "Node")
                        newPerson.isTopOfBloodline = true
                        modelContext.insert(newPerson)
                        trees.append(newPerson)
                    } else {
                        trees = roots

                    }
                    // Cross bloodline connections
                    crossBloodLineConnections = allCrossBloodLineConnections
                }
            if allMembers.isEmpty {
                Text("Welcome to the Family Tree App!")
                    .font(.headline)
                Text("Click the 'Add' button to start building your family tree.")
                    .font(.caption)
            }
            ScrollView([.vertical, .horizontal]) {
                HStack(alignment: .top, spacing: 50) {
                    ForEach($trees.sorted(by: { $0.wrappedValue.familySize > $1.wrappedValue.familySize }), id: \.id) { $tree in
                        makeTree(for: $tree)
                    }
                }
                .backgroundPreferenceValue(Key.self) { centers in
                    GeometryReader { proxy in
                        ZStack {
                            ForEach(Array(crossBloodLineConnections.enumerated()), id: \.element.fromChild) { index, connection in
                                if let from = centers[connection.fromChild],
                                   let to = centers[connection.toNewParent] {
                                    Path { path in
                                        path.move(to: proxy[from])
                                        path.addLine(to: proxy[to])
                                    }
                                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                    .foregroundStyle(ConnectionColor.allCases[index].color)
                                } else {
                                    VStack {
                                        Text("Missing anchor for \(name(for: connection.fromChild.uuidString)) or \(name(for: connection.toNewParent.uuidString))")
                                        Text("Here are the centers:")
                                        Text(centers.map { name(for: $0.key.uuidString) }.joined(separator: "\n"))
                                            .lineLimit(nil)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func name(for Id: String) -> String {
        allMembers.first(where: { $0.id.uuidString == Id})?.fullName ?? "Unknown"
    }

    @ViewBuilder
    func makeTree(for tree: Binding<FamilyMember>) -> some View {
        ZStack {
            VStack(alignment: .center, spacing: 20) {
                Text("\(tree.wrappedValue.lastName) Family")
                Diagram(
                    root: tree,
                    node: { node in
                        FamilyMemberView(
                            member: node.wrappedValue,
                            onDelete: { member in
                                tree.wrappedValue.delete(person: member)
                            },
                            newRoot: { newRoot in
                                tree.wrappedValue.isTopOfBloodline = false
                                tree.wrappedValue = newRoot
                            },
                            newBloodline: { child, parent in
                                trees.append(parent)
                                
                                // Capture the connection from the current root (the child)
                                // to the new bloodline root (the parent)
                                let newConnection = CrossBloodLineConnection(fromChild: child.id, toNewParent: parent.id)
                                crossBloodLineConnections.append(newConnection)
                                modelContext.insert(CrossBloodLineConnection(fromChild: child.id, toNewParent: parent.id))
                            },
                            outlineColor: provideOutlineColor(for: node.wrappedValue)
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

    private func provideOutlineColor(for person: FamilyMember) -> Color {
        if let indexOfConnection = crossBloodLineConnections
            .firstIndex(where: { $0.fromChild == person.id || $0.toNewParent == person.id })
        {
            return ConnectionColor.allCases[indexOfConnection].color
        } else {
            return .clear
        }
    }
}
