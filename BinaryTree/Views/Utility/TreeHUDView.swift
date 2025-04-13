//
//  TreeHUDView.swift
//  BinaryTree
//
//  Created by Alex Smithson on 4/11/25.
//

import SwiftUI

struct TreeHUDView<Content: View>: View {

    @Binding var manualConnectionMember: FamilyMember?
    @Binding var personDetailsToPresent: FamilyMember?

    @State private var zoom: CGFloat = 1.0

    let content: () -> Content

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            ScrollView([.horizontal, .vertical]) {
                content()
                    .scaleEffect(zoom)
                    .animation(.easeInOut, value: zoom)
            }

            HStack {
                if let manualConnectionMember {
                    addManualConnectionToast(manualConnectionMember)
                }
                Spacer()
                VStack(spacing: 12) {
                    zoomInButton()
                    zoomOutButton()
                }
            }
            .padding()
        }
        .animation(.easeInOut, value: manualConnectionMember != nil)
        .sheet(item: $personDetailsToPresent) { person in
            NavigationStack {
                FamilyMemberDetailView(member: person)
            }
        }
    }

    @ViewBuilder
    func addManualConnectionToast(_ manualConnectionMember: FamilyMember) -> some View {
        VStack {
            Capsule()
                .frame(width: 40, height: 6)
                .foregroundColor(.gray)
                .padding(.top, 8)

            Text("Long press another family member to make a connection to \(manualConnectionMember.fullName)")
                .padding()
        }
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.horizontal)
        .padding(.bottom, 20)
        .transition(.move(edge: .bottom))
        .zIndex(1) // keep it above other views
    }

    @ViewBuilder
    func zoomInButton() -> some View {
        Button(action: { zoom += 0.2 }) {
            Image(systemName: "plus.magnifyingglass")
                .padding()
                .background(Circle().fill(Color.white))
                .shadow(radius: 3)
        }
    }

    @ViewBuilder
    func zoomOutButton() -> some View {
        Button(action: { zoom = max(0.2, zoom - 0.2) }) {
            Image(systemName: "minus.magnifyingglass")
                .padding()
                .background(Circle().fill(Color.white))
                .shadow(radius: 3)
        }
    }
}
