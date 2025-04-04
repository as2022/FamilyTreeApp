//
//  Diagrams.swift
//  DiagramsSample
//
//  Created by Chris Eidhof on 16.12.19.
//  Copyright © 2019 objc.io. All rights reserved.
//

import SwiftUI

import SwiftUI

/// A simple Diagram. It's not very performant yet, but works great for smallish roots.
struct Diagram<V: View>: View {

    typealias Key = CollectDict<FamilyMember.ID, Anchor<CGPoint>>

    @Binding var root: FamilyMember
    var node: (Binding<FamilyMember>) -> V
    var newRoot: ((FamilyMember) -> Void)?

    var body: some View {
        VStack(alignment: .center) {
            if root.isMarriedIntoFamily || root.isTopOfBloodline {
                Button("Add Parent") {
                    let newParent = FamilyMember(firstName: "New", lastName: "Parent")
                    newParent.children = [root]
                    root.parent = newParent
                    if root.isTopOfBloodline {
                        newRoot?(newParent)
                    }
                }
            }
            HStack(alignment: .top, spacing: 20) {
                node($root)
                    .anchorPreference(key: Key.self, value: .center, transform: {
                        [self.root.id: $0]
                    })
                if let spouse = root.spouse {
                    Diagram(
                        root: Binding(get: { spouse }, set: { root.spouse = $0 }),
                        node: self.node
                    )
                }
            }
            HStack(alignment: .top, spacing: 20) {
                ForEach($root.children.sorted(by: { $0.wrappedValue.birthDate < $1.wrappedValue.birthDate }), id: \.id) { child in
                    Diagram(root: child, node: self.node)
                }
            }
        }
        .backgroundPreferenceValue(Key.self, { (centers: [FamilyMember.ID: Anchor<CGPoint>]) in
            GeometryReader { proxy in
                ForEach(self.root.children, id: \.id) { child in
                    if let from = centers[self.root.id], let to = centers[child.id] {
                        Line(from: proxy[from], to: proxy[to])
                            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .foregroundStyle(Color.brown.opacity(0.6))
                    }
                }
                if let spouse = root.spouse,
                   let from = centers[self.root.id],
                   let to = centers[spouse.id] {
                    Line(from: proxy[from], to: proxy[to])
                        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .foregroundStyle(Color.brown.opacity(0.6))
                }
            }
        })
    }
}
