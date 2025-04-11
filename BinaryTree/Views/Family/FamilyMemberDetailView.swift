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
    @State var memberDraft = FamilyMember()
    @Bindable var member: FamilyMember

    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                TextField("First Name", text: Binding(get: { memberDraft.firstName ?? "" }, set: { memberDraft.firstName = $0 }))
                    .focused($isFocused)
                TextField("Middle Name", text: Binding(get: { memberDraft.middleName ?? "" }, set: { memberDraft.middleName = $0.isEmpty ? nil : $0 }))
                TextField("Last Name", text: Binding(get: { memberDraft.lastName ?? "" }, set: { memberDraft.lastName = $0 }))
                Picker("Sex", selection: $memberDraft.sex) {
                    ForEach(Sex.allCases) { sex in
                        Text(sex.rawValue).tag(sex)
                    }
                }
                .pickerStyle(.segmented)
                TextField("Birthplace", text: Binding(get: { memberDraft.birthPlace ?? "" }, set: { memberDraft.birthPlace = $0 }))
                DatePicker(
                    "Birthdate",
                    selection: Binding(
                        get: { memberDraft.birthDate },
                        set: {
                            memberDraft.birthDate = $0
                            memberDraft.parent?.children.sort { $0.birthDate < $1.birthDate }
                        }),
                    displayedComponents: .date
                )
            }
        }
        .navigationTitle(memberDraft.fullName)
        .onAppear {
            memberDraft.updateDetails(using: member)
        }
        .onDisappear {
            member.updateDetails(using: memberDraft)
        }
    }
}
