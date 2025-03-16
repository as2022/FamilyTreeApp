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
    let tree: Tree<A>
    let node: (A) -> V
    
    typealias Key = CollectDict<A.ID, Anchor<CGPoint>>

    var body: some View {
        VStack(alignment: .center) {
            node(tree.value)
               .anchorPreference(key: Key.self, value: .center, transform: {
                   [self.tree.value.id: $0]
               })
            HStack(alignment: .bottom, spacing: 10) {
                ForEach(tree.children, id: \.value.id, content: { child in
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
                    .stroke()
                })
            }
        })
    }
}
