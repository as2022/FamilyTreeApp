//
//  Sex.swift
//  FamilyTree
//
//  Created by Alex Smithson on 4/13/25.
//

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
