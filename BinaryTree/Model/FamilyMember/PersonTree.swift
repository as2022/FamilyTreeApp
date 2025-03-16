//
//  String Tree.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/15/25.
//

import Foundation

let mainPerson = FamilyMember(firstName: "Ralph", lastName: "Smith", birthDate: Date(), birthPlace: "Iowa")
let personTree = Tree<FamilyMember>(mainPerson, children: [])
let uniquePersonTree = personTree.map(Unique.init)

extension Tree where A == Unique<FamilyMember> {
    mutating func insert(_ person: FamilyMember) {
        if person.hashValue < value.value.hashValue {
            if children.count > 0 {
                children[0].insert(person)
            } else {
                children.append(Tree(Unique(person)))
            }
        } else {
            if children.count == 2 {
                children[1].insert(person)
            } else if children.count == 1 && children[0].value.value.hashValue > person.hashValue {
                children[0].insert(person)
            } else {
                children.append(Tree(Unique(person)))
            }
        }
    }
}
