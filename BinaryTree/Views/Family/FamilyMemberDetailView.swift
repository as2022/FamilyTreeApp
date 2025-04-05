//
//  FamilyMemberDetailView.swift
//  FamilyTree
//
//  Created by Alex Smithson on 3/1/25.
//

import SwiftData
import SwiftUI

struct FamilyMemberDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allMembers: [FamilyMember]

    @FocusState private var isFocused: Bool
    @Bindable var member: FamilyMember

    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                TextField("First Name", text: $member.firstName)
                    .focused($isFocused)
                    .onAppear {
                        isFocused = member.firstName.isEmpty
                        member.children.forEach {
                            $0.parent = member
                        }
                    }
                TextField("Middle Name", text: Binding(get: { member.middleName ?? "" }, set: { member.middleName = $0.isEmpty ? nil : $0 }))
                TextField("Last Name", text: $member.lastName)
                Picker("Sex", selection: $member.sex) {
                    ForEach(Sex.allCases) { sex in
                        Text(sex.rawValue).tag(sex)
                    }
                }
                .pickerStyle(.segmented)
                TextField("Birthplace", text: $member.birthPlace)
                DatePicker(
                    "Birthdate",
                    selection: Binding(
                        get: { member.birthDate },
                        set: {
                            member.birthDate = $0
                            member.parent?.children.sort { $0.birthDate < $1.birthDate }
                        }),
                    displayedComponents: .date
                )
            }
        }
        .navigationTitle(member.fullName)
    }

    func getAllChildren() -> [FamilyMember] {
        var allChildren = member.parent?.children ?? []
        if let connectionChild = member.parent?.bloodlineConnectionChild {
            allChildren.append(connectionChild)
        }
        return allChildren
    }
}
