//
//  FamilyMemberDTO.swift
//  BinaryTree
//
//  Created by Alex Smithson on 4/13/25.
//

import Foundation

class FamilyMemberDTO: Codable, Identifiable {

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

    // Reference Properties
    var parentId: UUID?
    var spouseId: UUID?
    var childrenIds: [UUID]
    var bloodlineConnectionChildId: UUID?

    init(clientModel: FamilyMember) {
        self.id = clientModel.id
        self.firstName = clientModel.firstName
        self.middleName = clientModel.middleName
        self.lastName = clientModel.lastName
        self.suffix = clientModel.suffix
        self.sex = clientModel.sex
        self.birthDate = clientModel.birthDate
        self.birthPlace = clientModel.birthPlace
        self.connectsTwoBloodlines = clientModel.connectsTwoBloodlines
        self.isMarriedIntoFamily = clientModel.isMarriedIntoFamily
        self.isTopOfBloodline = clientModel.isTopOfBloodline
        self.parentId = clientModel.parent?.id
        self.spouseId = clientModel.spouse?.id
        self.childrenIds = clientModel.children.map(\.self).map(\.id)
        self.bloodlineConnectionChildId = clientModel.bloodlineConnectionChild?.id
    }
}
