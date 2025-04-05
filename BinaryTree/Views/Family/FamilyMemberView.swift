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
    var newRoot: ((FamilyMember) -> Void)?
    var newBloodline: (_ child: FamilyMember, _ newParent: FamilyMember) -> Void
    let outlineColor: Color

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
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(backgroundColor)
                            .stroke(outlineColor, lineWidth: 10)
                    )
                }
                .sheet(isPresented: $isDetailPresented) {
                    NavigationStack {
                        FamilyMemberDetailView(member: member)
                    }
                }
            }

            HStack(spacing: 4) {
                if !member.isMarriedIntoFamily {
                    Button(action: {
                        let newChild = FamilyMember(lastName: lastNameForChild, parent: member)
                        member.children.append(newChild)
                    }) {
                        Image(systemName: "arrowshape.down.fill")
                    }
                    Button(action: {
                        let newSpouse = FamilyMember(sex: member.sex?.opposite ?? nil, isMarriedIntoFamily: true)
                        member.spouse = newSpouse
                    }) {
                        Image(systemName: "heart.circle")
                    }
                }
                if member.isTopOfBloodline || member.isMarriedIntoFamily, !member.connectsTwoBloodlines {
                    Button(action: {
                        let newParent = FamilyMember(firstName: "New", lastName: "Parent")
                        newParent.isTopOfBloodline = true
                        member.parent = newParent

                        if member.isTopOfBloodline {
                            newParent.children = [member]
                            newRoot?(newParent)
                        } else {
                            newParent.connectsTwoBloodlines = true
                            newParent.bloodlineConnectionChild = member
                            member.connectsTwoBloodlines = true

                            newBloodline(member, newParent)
                        }
                    }) {
                        Image(systemName: "arrowshape.up.fill")
                    }
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
        member.sex == .male ? ColorTheme.softBlue :  member.sex == .female ? ColorTheme.softPink : ColorTheme.lightGray
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
