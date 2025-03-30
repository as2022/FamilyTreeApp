//
//  Tree.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/15/25.
//

import SwiftUICore

/// A simple Tree datastructure that holds nodes with `A` as the value.
struct Tree<A> {
    var value: A
    var spouse: A?
    var children: [Tree<A>] = []
    init(_ value: A, children: [Tree<A>] = [], spouse: A? = nil) {
        self.value = value
        self.children = children
        self.spouse = spouse
    }
}

extension Tree {
    func map<B>(_ transform: (A) -> B) -> Tree<B> {
        return Tree<B>(transform(value), children: children.map({ $0.map(transform) }))
    }
}

class Unique<A>: Identifiable {
    let value: A
    init(_ value: A) { self.value = value }
}

struct CollectDict<Key: Hashable, Value>: PreferenceKey {
    static var defaultValue: [Key:Value] { [:] }
    static func reduce(value: inout [Key:Value], nextValue: () -> [Key:Value]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
