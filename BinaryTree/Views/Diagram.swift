//
//  Diagrams.swift
//  DiagramsSample
//
//  Created by Chris Eidhof on 16.12.19.
//  Copyright © 2019 objc.io. All rights reserved.
//

import SwiftUI

/// A simple Diagram. It's not very performant yet, but works great for smallish trees.
struct Diagram<A: Identifiable, V: View>: View {
    @Binding var tree: Tree<A>
    var node: (Binding<Tree<A>>) -> V

    typealias Key = CollectDict<A.ID, Anchor<CGPoint>>

    var body: some View {
        VStack(alignment: .center) {
            HStack(spacing: 20) {
                node($tree)
                    .anchorPreference(key: Key.self, value: .center, transform: {
                        [self.tree.value.id: $0]
                    })
                if let spouse = tree.spouse {
                    Diagram(
                        tree: Binding(get: { Tree<A>(spouse, children: []) }, set: { tree.spouse = $0.value }) ,
                        node: self.node
                    )
                }
            }
            HStack(alignment: .top, spacing: 20) {
                ForEach($tree.children, id: \.value.id, content: { child in
                    Diagram(tree: child, node: self.node)
                })
            }
        }.backgroundPreferenceValue(Key.self, { (centers: [A.ID: Anchor<CGPoint>]) in
            GeometryReader { proxy in
                ForEach(self.tree.children, id: \.value.id, content: {
                 child in
                    Line(
                        from: proxy[centers[self.tree.value.id]!],
                        to: proxy[centers[child.value.id]!])
                    .stroke(style: StrokeStyle.init(lineWidth: 10, lineCap: .round))
                    .foregroundStyle(Color.brown.opacity(0.6))
                })
                if let spouse = tree.spouse {
                    Line(
                        from: proxy[centers[self.tree.value.id]!],
                        to: proxy[centers[spouse.id]!])
                    .stroke(style: StrokeStyle.init(lineWidth: 10, lineCap: .round))
                    .foregroundStyle(Color.brown.opacity(0.6))
                }
            }
        })
    }
}
