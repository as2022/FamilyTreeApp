//
//  AnchorKey.swift
//  FamilyTree
//
//  Created by Alex Smithson on 3/15/25.
//

import SwiftUICore

/// Key for anchoring a FamilyMemberView at a specified point
struct AnchorKey: PreferenceKey {

    static var defaultValue: [FamilyMember.ID : Anchor<CGPoint>] { [:] }

    static func reduce(
        value: inout [FamilyMember.ID : Anchor<CGPoint>],
        nextValue: () -> [FamilyMember.ID : Anchor<CGPoint>]
    ) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
