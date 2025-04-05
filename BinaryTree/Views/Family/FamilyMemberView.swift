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
    let onDelete: (FamilyMember, _ needsHelp: Bool) -> Void
    var newRoot: ((FamilyMember) -> Void)?
    var newBloodline: (_ child: FamilyMember, FamilyMember) -> Void
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
                        Capsule()
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

            HStack(spacing: 12) {
                if !member.isMarriedIntoFamily {
                    // Add Child Button
                    Button(action: {
                        let newChild = FamilyMember(lastName: lastNameForChild, parent: member)
                        member.children.append(newChild)
                    }) {
                        Image(systemName: "arrowshape.down.fill")
                    }
                    if member.spouse == nil  {
                        // Add Spouse Button
                        Button(action: {
                            let newSpouse = FamilyMember(sex: member.sex?.opposite ?? nil, isMarriedIntoFamily: true)
                            
                            member.spouse = newSpouse
                        }) {
                            Image(systemName: "heart.circle")
                        }
                    }
                }
                if member.isTopOfBloodline || member.isMarriedIntoFamily && !member.connectsTwoBloodlines {
                    // Add Parent Button
                    Button(action: {
                        let newParent = FamilyMember(firstName: "Parent", lastName: member.lastName, isTopOfBloodline: true)
                        member.parent = newParent

                        if member.isTopOfBloodline {
                            newParent.children = [member]
                            member.isTopOfBloodline = false
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
                    let newTopOfBloodline = member.removeReferences()
                    if let newTopOfBloodline {
                        newRoot?(newTopOfBloodline)
                    }
                    onDelete(member, member.isMarriedIntoFamily)
                } label: {
                    Image(systemName: "trash")
                }
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
        member.sex == .male ? ColorTheme.softBlue :  member.sex == .female ? ColorTheme.softPink : ColorTheme.lightGray
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
