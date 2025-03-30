//
//  String Tree.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/15/25.
//

import Foundation

extension FamilyMember {

    func delete(person: FamilyMember) {
        guard !children.contains(where: { $0 == person }) else {
            children.removeAll(where: { $0 == person })
            return
        }

        children.forEach { child in
            child.delete(person: person)
        }
    }
}
