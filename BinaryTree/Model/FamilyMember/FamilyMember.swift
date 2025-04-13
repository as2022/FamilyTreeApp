//
//  FamilyMember.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/15/25.
//

import Foundation
import SwiftData

@Model
class FamilyMember: Codable, Identifiable {
    var fullName: String {
        [firstName, middleName, lastName].compactMap { $0 }.joined(separator: " ")
    }

    // Intrinsic properties
    var id: UUID
    var firstName: String?
    var middleName: String?
    var lastName: String?
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
}
