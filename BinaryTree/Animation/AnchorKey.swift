//
//  Tree.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/15/25.
//

import SwiftUICore

struct AnchorKey: PreferenceKey {

    static var defaultValue: [FamilyMember.ID : Anchor<CGPoint>] { [:] }

    static func reduce(
        value: inout [FamilyMember.ID : Anchor<CGPoint>],
        nextValue: () -> [FamilyMember.ID : Anchor<CGPoint>]
    ) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
