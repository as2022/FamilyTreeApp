//
//  Diagrams.swift
//  DiagramsSample
//
//  Created by Chris Eidhof on 16.12.19.
//  Copyright © 2019 objc.io. All rights reserved.
//

import SwiftUI

/// A simple Diagram. It's not very performant yet, but works great for smallish trees.
struct Diagram<V: View>: View {
    @Binding var tree: FamilyMember
    var node: (Binding<FamilyMember>) -> V

    typealias Key = CollectDict<FamilyMember.ID, Anchor<CGPoint>>

    var body: some View {
        VStack(alignment: .center) {
            HStack(spacing: 20) {
                node($tree)
                    .anchorPreference(key: Key.self, value: .center, transform: {
                        [self.tree.id: $0]
                    })
                if let spouse = tree.spouse {
                    Diagram(
                        tree: Binding(get: { spouse }, set: { tree.spouse = $0 }) ,
                        node: self.node
                    )
                }
            }
            HStack(alignment: .top, spacing: 20) {
                ForEach($tree.children, id: \.id, content: { child in
                    Diagram(tree: child, node: self.node)
                })
            }
        }.backgroundPreferenceValue(Key.self, { (centers: [FamilyMember.ID: Anchor<CGPoint>]) in
            GeometryReader { proxy in
                ForEach(self.tree.children, id: \.id, content: {
                 child in
                    Line(
                        from: proxy[centers[self.tree.id]!],
                        to: proxy[centers[child.id]!])
                    .stroke(style: StrokeStyle.init(lineWidth: 10, lineCap: .round))
                    .foregroundStyle(Color.brown.opacity(0.6))
                })
                if let spouse = tree.spouse {
                    Line(
                        from: proxy[centers[self.tree.id]!],
                        to: proxy[centers[spouse.id]!])
                    .stroke(style: StrokeStyle.init(lineWidth: 10, lineCap: .round))
                    .foregroundStyle(Color.brown.opacity(0.6))
                }
            }
        })
    }
}
