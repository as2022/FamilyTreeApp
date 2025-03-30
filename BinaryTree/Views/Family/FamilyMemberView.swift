//
//  FamilyMemberView.swift
//  FamilyTree
//
//  Created by Alex Smithson on 3/1/25.
//

import SwiftUI

struct FamilyMemberView: View {

    @Bindable var member: FamilyMember
    @State private var isDetailPresented = false
    let onDelete: (FamilyMember) -> Void

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    isDetailPresented = true
                }) {
                    VStack {
                        Text(member.fullName)
                            .font(.headline)
                        Text("Born: \(formattedDate(member.birthDate))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(backgroundColor)
                    .cornerRadius(16)
                }
                .sheet(isPresented: $isDetailPresented) {
                    NavigationStack {
                        FamilyMemberDetailView(member: member)
                    }
                }
            }

            if !member.isMarriedIntoFamily {
                HStack(spacing: 4) {
                    Button(action: {
                        let newChild = FamilyMember(lastName: lastNameForChild)
                        member.children.append(newChild)
                    }) {
                        Label("Child", systemImage: "person.fill.badge.plus")
                    }
                    Button(action: {
                        let newSpouse = FamilyMember(sex: member.sex?.opposite ?? nil, isMarriedIntoFamily: true)
                        member.spouse = newSpouse
                    }) {
                        Label("Spouse", systemImage: "heart.circle")
                    }
                    Button(role: .destructive) {
                        onDelete(member)
                    } label: {
                        Image(systemName: "trash")
                    }
                }
                .padding(.top, 4)
            }
        }
    }

    private var lastNameForChild: String {
        if member.sex == .male {
            member.lastName
        } else if let spouse = member.spouse, spouse.sex == .male {
            spouse.lastName
        } else {
            ""
        }
    }

    private var backgroundColor: Color {
        member.sex == .male ? CustomColor.softBlue :  member.sex == .female ? CustomColor.softPink : CustomColor.lightGray
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
