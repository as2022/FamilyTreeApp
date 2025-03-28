//
//  FamilyMemberView.swift
//  FamilyTree
//
//  Created by Alex Smithson on 3/1/25.
//

import SwiftUI

struct FamilyMemberView: View {
    @Environment(\.modelContext) private var modelContext
    var member: FamilyMember
    @State private var isDetailPresented = false
    let onChildAdd: () -> Void

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    isDetailPresented = true
                }) {
                    VStack {
                        Text("\(member.firstName) \(member.lastName)")
                            .font(.headline)
                        Text("Born: \(formattedDate(member.birthDate))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
                }
                Button(action: {
                    let newChild = FamilyMember(firstName: "", lastName: member.lastName, birthDate: Date(), birthPlace: "")
                    modelContext.insert(newChild)
                    member.children.append(newChild)
                    onChildAdd()
                }) {
                    Image(systemName: "person.crop.circle.badge.plus")
                }
                .padding(.leading, 4)
                .sheet(isPresented: $isDetailPresented) {
                    NavigationStack {
                        FamilyMemberDetailView(member: member)
                    }
                }
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
