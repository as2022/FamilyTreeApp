//
//  String Tree.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/15/25.
//

import Foundation

extension Tree where A == Unique<FamilyMember> {
    mutating func insert(child newChild: FamilyMember, for parent: FamilyMember) {
        guard parent.id != value.value.id else {
            children.append(Tree(Unique(newChild)))
            return
        }
        children.forEach { child in
            insert(child: newChild, for: child.value.value)
        }
        // MARK: - OLD LOGIC
//        if child.hashValue < value.value.hashValue {
//            if children.count > 0 {
//                children[0].insert(child: child)
//            } else {
//                children.append(Tree(Unique(child)))
//            }
//        } else {
//            if children.count == 2 {
//                children[1].insert(child: child)
//            } else if children.count == 1 && children[0].value.value.hashValue > child.hashValue {
//                children[0].insert(child: child)
//            } else {
//                children.append(Tree(Unique(child)))
//            }
//        }
    }

    mutating func insert(spouse newSpouse: FamilyMember, for person: FamilyMember) {

        guard person.id != value.value.id else {
            spouse = Unique(newSpouse)
            return
        }

        children.forEach { child in
            insert(spouse: newSpouse, for: child.value.value)
        }
    }

    mutating func add(child: FamilyMember) {
        children.append(Tree(Unique(child)))
    }

    mutating func add(spouse: FamilyMember) {
        self.spouse = Unique(spouse)
    }
}
