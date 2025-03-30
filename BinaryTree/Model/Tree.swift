//
//  Tree.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/15/25.
//

import SwiftUICore

struct CollectDict<Key: Hashable, Value>: PreferenceKey {
    static var defaultValue: [Key:Value] { [:] }
    static func reduce(value: inout [Key:Value], nextValue: () -> [Key:Value]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
