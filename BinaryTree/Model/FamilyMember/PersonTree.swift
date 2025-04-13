//
//  String Tree.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/15/25.
//

import Foundation

extension FamilyMember {

    var familySize: Int {
        let childrenCount = children.reduce(0) { $0 + $1.familySize }
        let spouseCount = spouse != nil ? 1 : 0
        return 1 + spouseCount + childrenCount
    }

    func delete(spouse: FamilyMember) {
        guard self.spouse != spouse else {
            self.spouse = nil
            return
        }

        children.forEach { child in
            child.delete(spouse: spouse)
        }
    }

    func removeReferences() -> FamilyMember? {
        // remove spouses reference to self
        spouse?.spouse = nil
        // Update bloodline relationships
        if let bloodlineConnectionChild {
            bloodlineConnectionChild.parent = nil
            bloodlineConnectionChild.connectsTwoBloodlines = false
        }

        // Final removal, parent's reference to self, will return a new root node if necessary
        if let parent {
            parent.children.removeAll(where: { $0 === self })
            // if there is no parent
        } else if isTopOfBloodline && children.count < 2 {
            // return the child as a the new top Of Bloodline
            if let child = children.first {
                child.parent = nil
                child.isTopOfBloodline = true
                return child
            }
        }
        return nil
    }

    func updateDetails(using other: FamilyMember) {
        firstName = other.firstName
        middleName = other.middleName
        lastName = other.lastName
        sex = other.sex
        birthDate = other.birthDate
        birthPlace = other.birthPlace
    }
}
