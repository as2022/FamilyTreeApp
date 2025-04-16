//
//  CrossBloodlineConnection.swift
//  BinaryTree
//
//  Created by Alex Smithson on 4/13/25.
//

import Foundation
import SwiftData

@Model
class CrossBloodlineConnection: Codable {

    var fromChild: UUID
    var toNewParent: UUID

    var id: String {
        "\(fromChild.uuidString)_\(toNewParent.uuidString)"
    }

    init(fromChild: UUID, toNewParent: UUID) {
        self.fromChild = fromChild
        self.toNewParent = toNewParent
    }

    // MARK: Codable

    enum CodingKeys: String, CodingKey {
        case fromChild
        case toNewParent
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fromChild = try container.decode(UUID.self, forKey: .fromChild)
        let toNewParent = try container.decode(UUID.self, forKey: .toNewParent)
        self.init(fromChild: fromChild, toNewParent: toNewParent)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fromChild, forKey: .fromChild)
        try container.encode(toNewParent, forKey: .toNewParent)
    }
}
