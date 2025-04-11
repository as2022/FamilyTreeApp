//
//  ZoomableView.swift
//  BinaryTree
//
//  Created by Alex Smithson on 4/11/25.
//

import SwiftUI

struct ZoomableView<Content: View>: View {
    @State private var zoom: CGFloat = 1.0
    let content: () -> Content

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView([.horizontal, .vertical]) {
                content()
                    .scaleEffect(zoom)
                    .animation(.easeInOut, value: zoom)
            }

            VStack(spacing: 12) {
                Button(action: { zoom += 0.2 }) {
                    Image(systemName: "plus.magnifyingglass")
                        .padding()
                        .background(Circle().fill(Color.white))
                        .shadow(radius: 3)
                }

                Button(action: { zoom = max(0.2, zoom - 0.2) }) {
                    Image(systemName: "minus.magnifyingglass")
                        .padding()
                        .background(Circle().fill(Color.white))
                        .shadow(radius: 3)
                }
            }
            .padding()
        }
    }
}
