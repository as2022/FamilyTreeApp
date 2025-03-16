//
//  FamilyMember.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/15/25.
//

import Foundation
import SwiftData

@Model
class FamilyMember: Identifiable {
    var fullName: String {
        [firstName, middleName, lastName].compactMap { $0 }.joined(separator: " ")
    }
    var id: UUID
    var firstName: String
    var middleName: String?
    var lastName: String
    var birthDate: Date
    var birthPlace: String

    @Relationship var father: FamilyMember?
    @Relationship var mother: FamilyMember?
    @Relationship var siblings: [FamilyMember]
    @Relationship var spouses: [FamilyMember]
    @Relationship var children: [FamilyMember]
    
    init(firstName: String, middleName: String? = nil, lastName: String, birthDate: Date, birthPlace: String) {
        self.id = UUID()
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.birthDate = birthDate
        self.birthPlace = birthPlace
        self.siblings = []
        self.spouses = []
        self.children = []
    }
}
