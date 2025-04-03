//
//  Diagrams.swift
//  DiagramsSample
//
//  Created by Chris Eidhof on 16.12.19.
//  Copyright © 2019 objc.io. All rights reserved.
//

import SwiftUI

/// A simple Diagram. It's not very performant yet, but works great for smallish roots.
struct Diagram<V: View>: View {
    @Binding var root: FamilyMember
    var node: (Binding<FamilyMember>) -> V

    typealias Key = CollectDict<FamilyMember.ID, Anchor<CGPoint>>

    var body: some View {
        VStack(alignment: .center) {
            HStack(spacing: 20) {
                node($root)
                    .anchorPreference(key: Key.self, value: .center, transform: {
                        [self.root.id: $0]
                    })
                if let spouse = root.spouse {
                    Diagram(
                        root: Binding(get: { spouse }, set: { root.spouse = $0 }) ,
                        node: self.node
                    )
                }
            }
            HStack(alignment: .top, spacing: 20) {
                ForEach($root.children.sorted(by: { $0.wrappedValue.birthDate < $1.wrappedValue.birthDate }), id: \.id) { child in
                    Diagram(root: child, node: self.node)
                }
            }
        }.backgroundPreferenceValue(Key.self, { (centers: [FamilyMember.ID: Anchor<CGPoint>]) in
            GeometryReader { proxy in
                ForEach(self.root.children, id: \.id, content: {
                 child in
                    Line(
                        from: proxy[centers[self.root.id]!],
                        to: proxy[centers[child.id]!])
                    .stroke(style: StrokeStyle.init(lineWidth: 10, lineCap: .round))
                    .foregroundStyle(Color.brown.opacity(0.6))
                })
                if let spouse = root.spouse {
                    Line(
                        from: proxy[centers[self.root.id]!],
                        to: proxy[centers[spouse.id]!])
                    .stroke(style: StrokeStyle.init(lineWidth: 10, lineCap: .round))
                    .foregroundStyle(Color.brown.opacity(0.6))
                }
            }
        })
    }
}
