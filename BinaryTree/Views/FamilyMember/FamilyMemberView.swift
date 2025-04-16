//
//  FamilyMemberView.swift
//  FamilyTree
//
//  Created by Alex Smithson on 3/1/25.
//

import SwiftUI

struct FamilyMemberView: View {

    @Bindable var member: FamilyMember
    let onDelete: (FamilyMember, _ needsHelp: Bool) -> Void
    var newRoot: ((FamilyMember) -> Void)?
    var newBloodline: (_ child: FamilyMember, FamilyMember) -> Void
    let outlineColor: Color

    var body: some View {
        VStack {
            // TODO: I think this HStack can be deleted
            HStack {
                VStack {
                    Text(member.fullName)
                        .font(.headline)
                        .foregroundColor(genderColor)
                    Text("Born: \(formattedDate(member.birthDate))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(
                    Capsule()
                        .fill(ColorTheme.lightGreen)
                        .stroke(outlineColor, lineWidth: 10)
                )
            }

            HStack(spacing: 12) {
                if !member.isMarriedIntoFamily {
                    // Add Child Button
                    addChildButton()
                    if member.spouse == nil  {
                        addSpouseButton()
                    }
                }
                if member.isTopOfBloodline || member.isMarriedIntoFamily && !member.connectsTwoBloodlines {
                    // Add Parent Button
                    addParentButton()
                }
                deleteButton()
            }
        }
    }

    // MARK: - ViewBuilders

    @ViewBuilder
    private func deleteButton() -> some View {
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

    @ViewBuilder
    private func addChildButton() -> some View {
        Button(action: {
            let newChild = FamilyMember(lastName: lastNameForChild, parent: member)
            member.children.append(newChild)
        }) {
            Image(systemName: "arrowshape.down.fill")
        }
    }

    @ViewBuilder
    private func addSpouseButton() -> some View {
        Button(action: {
            let newSpouse = FamilyMember(sex: member.sex?.opposite ?? nil, isMarriedIntoFamily: true)
            member.spouse = newSpouse
        }) {
            Image(systemName: "heart.circle")
        }
    }

    @ViewBuilder
    private func addParentButton() -> some View {
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

    // MARK: - Helpers

    private var lastNameForChild: String? {
        if member.sex == .male {
            member.lastName
        } else if let spouse = member.spouse, spouse.sex == .male {
            spouse.lastName
        } else {
            ""
        }
    }

    private var genderColor: Color {
        member.sex == .male ? ColorTheme.deepBlue :  member.sex == .female ? ColorTheme.brightPink : ColorTheme.darkGray
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
