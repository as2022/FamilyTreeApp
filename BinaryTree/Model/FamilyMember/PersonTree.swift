//
//  String Tree.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/15/25.
//

import Foundation

extension FamilyMember {

    func delete(person: FamilyMember) {
        if children.contains(where: { $0 == person }) {
            children.removeAll(where: { $0 == person })
            return
        } else if spouse == person {
            spouse = nil
        }

        children.forEach { child in
            child.delete(person: person)
        }
    }
}
