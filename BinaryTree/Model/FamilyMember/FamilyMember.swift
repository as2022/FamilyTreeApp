//
//  FamilyMember.swift
//  FamilyTree
//
//  Created by Alex Smithson on 3/15/25.
//

import Foundation
import SwiftData

@Model
class FamilyMember: Identifiable {
    var fullName: String {
        [firstName, middleName, lastName, suffix].compactMap { $0 }.joined(separator: " ")
    }

    // Intrinsic properties
    var id: UUID
    var firstName: String?
    var middleName: String?
    var lastName: String?
    var suffix: String?
    var sex: Sex?
    var birthDate: Date
    var birthPlace: String?

    // Relational Properties
    var connectsTwoBloodlines: Bool
    var isMarriedIntoFamily: Bool
    var isTopOfBloodline: Bool

    @Relationship var parent: FamilyMember?
    @Relationship var spouse: FamilyMember?
    @Relationship var bloodlineConnectionChild: FamilyMember?
    @Relationship var children: [FamilyMember]
    
    init(firstName: String? = nil,
         middleName: String? = nil,
         lastName: String? = nil,
         suffix: String? = nil,
         sex: Sex? = nil,
         birthDate: Date = Date(),
         birthPlace: String = "",
         parent: FamilyMember? = nil,
         spouse: FamilyMember? = nil,
         bloodlineConnectionChild: FamilyMember? = nil,
         isMarriedIntoFamily: Bool = false,
         connectsTwoBloodlines: Bool = false,
         isTopOfBloodline: Bool = false
    ) {
        self.id = UUID()
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.suffix = suffix
        self.sex = sex
        self.birthDate = birthDate
        self.birthPlace = birthPlace
        self.parent = parent
        self.spouse = spouse
        self.connectsTwoBloodlines = connectsTwoBloodlines
        self.bloodlineConnectionChild = bloodlineConnectionChild
        self.isMarriedIntoFamily = isMarriedIntoFamily
        self.isTopOfBloodline = isTopOfBloodline
        self.children = []
    }

    init(dto: FamilyMemberDTO) {
        self.id = dto.id
        self.firstName = dto.firstName
        self.middleName = dto.middleName
        self.lastName = dto.lastName
        self.suffix = dto.suffix
        self.sex = dto.sex
        self.birthDate = dto.birthDate
        self.birthPlace = dto.birthPlace
        self.connectsTwoBloodlines = dto.connectsTwoBloodlines
        self.isMarriedIntoFamily = dto.isMarriedIntoFamily
        self.isTopOfBloodline = dto.isTopOfBloodline
        self.parent = nil
        self.spouse = nil
        self.children = []
        self.bloodlineConnectionChild = nil
    }
}

// MARK: - Helper Functions

extension FamilyMember {

    /// The number of descendants from the family member and their spouses, including self and spouse.
    var familySize: Int {
        let childrenCount = children.reduce(0) { $0 + $1.familySize }
        let spouseCount = spouse != nil ? 1 : 0
        return 1 + spouseCount + childrenCount
    }

    // TODO: Need to revisit this logic
    func delete(spouse: FamilyMember) {
        guard self.spouse != spouse else {
            self.spouse = nil
            return
        }

        children.forEach { child in
            child.delete(spouse: spouse)
        }
    }

    // TODO: Need to revisit this logic
    func delete(_ member: FamilyMember) {
        guard children.contains(where: { $0 == member }) else {
            self.children.removeAll(where: { $0 == member })
            print("Removing: \(member.fullName)")
            return
        }

        children.forEach { child in
            child.delete(member)
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
}
