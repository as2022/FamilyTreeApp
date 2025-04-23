//
//  ConnectionDrawerModifier.swift
//  FamilyTree
//
//  Created by Alex Smithson on 4/12/25.
//

import SwiftUI

struct ConnectionDrawerModifier: ViewModifier {

    @Binding var connections: [CrossBloodlineConnection]

    func body(content: Content) -> some View {
        content
            .backgroundPreferenceValue(AnchorKey.self) { centers in
                GeometryReader { proxy in
                    ZStack {
                        ForEach(Array(connections.enumerated()), id: \.element.fromChild) { index, connection in
                            if let from = centers[connection.fromChild],
                               let to = centers[connection.toNewParent] {
                                Path { path in
                                    path.move(to: proxy[from])
                                    path.addLine(to: proxy[to])
                                }
                                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                .foregroundStyle(ConnectionColor.allCases[index].color)
                            } else {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .scaleEffect(5)
                                    .background(Color.red.opacity(0.9))
                            }
                        }
                    }
                }
            }
    }
}

extension View {
    func drawConnections(for connections: Binding<[CrossBloodlineConnection]>) -> some View {
        self.modifier(ConnectionDrawerModifier(connections: connections))
    }
}
