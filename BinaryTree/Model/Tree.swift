//
//  Tree.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/15/25.
//

import SwiftData
import SwiftUICore

struct CollectDict<Key: Hashable, Value>: PreferenceKey {
    static var defaultValue: [Key:Value] { [:] }
    static func reduce(value: inout [Key:Value], nextValue: () -> [Key:Value]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

@Model
class CrossBloodLineConnection {

    var fromChild: FamilyMember.ID
    var toNewParent: FamilyMember.ID

    init(fromChild: FamilyMember.ID, toNewParent: FamilyMember.ID) {
        self.fromChild = fromChild
        self.toNewParent = toNewParent
    }
}
