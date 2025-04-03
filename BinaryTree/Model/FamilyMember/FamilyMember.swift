//
//  FamilyMember.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/15/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class FamilyMember: Identifiable {
    var fullName: String {
        [firstName, middleName, lastName].compactMap { $0 }.joined(separator: " ")
    }
    var id: UUID
    var firstName: String
    var middleName: String?
    var lastName: String
    var sex: Sex?
    var birthDate: Date
    var birthPlace: String
    var isMarriedIntoFamily: Bool

    @Relationship var parent: FamilyMember?
    @Relationship var siblings: [FamilyMember]
    @Relationship var spouse: FamilyMember?
    @Relationship var children: [FamilyMember]
    
    init(firstName: String = "",
         middleName: String? = nil,
         lastName: String = "",
         sex: Sex? = nil,
         birthDate: Date = Date(),
         birthPlace: String = "",
         parent: FamilyMember? = nil,
         isMarriedIntoFamily: Bool = false
    ) {
        self.id = UUID()
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.sex = sex
        self.birthDate = birthDate
        self.birthPlace = birthPlace
        self.parent = parent
        self.isMarriedIntoFamily = isMarriedIntoFamily
        self.siblings = []
        self.children = []
    }
}

enum Sex: String, CaseIterable, Identifiable, Codable {

    case male
    case female

    var id: String { self.rawValue }

    var opposite: Sex {
        switch self {
        case .male: return .female
        case .female: return .male
        }
    }
}
