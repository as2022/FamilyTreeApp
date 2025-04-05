//
//  ConnectionColor.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/28/25.
//

import SwiftUI

enum ConnectionColor: CaseIterable {

    case green
    case orange
    case violet
    case blue
    case yellow
    case red
    case indigo

    var color: Color {
        switch self {
        case .red:
            return Color(red: 1.0, green: 0.0, blue: 0.0)
        case .orange:
            return Color(red: 1.0, green: 0.5, blue: 0.0)
        case .yellow:
            return Color(red: 1.0, green: 1.0, blue: 0.0)
        case .green:
            return Color(red: 0.0, green: 1.0, blue: 0.0)
        case .blue:
            return Color(red: 0.0, green: 0.0, blue: 1.0)
        case .indigo:
            return Color(red: 0.29, green: 0.0, blue: 0.51)
        case .violet:
            return Color(red: 0.56, green: 0.0, blue: 1.0)
        }
    }
}
