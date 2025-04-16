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

    @FocusState private var isFirstNameFocused: Bool
    @State var memberDraft = FamilyMember()
    @Bindable var member: FamilyMember

    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                TextField("First Name", text: customBinding(for: $memberDraft.firstName))
                    .focused($isFirstNameFocused)
                TextField("Middle Name", text: customBinding(for: $memberDraft.middleName))
                TextField("Last Name", text: customBinding(for: $memberDraft.lastName))
                TextField("Suffix", text: customBinding(for: $memberDraft.suffix))
                Picker("Sex", selection: $memberDraft.sex) {
                    ForEach(Sex.allCases) { sex in
                        Text(sex.rawValue).tag(sex)
                    }
                }
                .pickerStyle(.segmented)
                TextField("Birthplace", text: customBinding(for: $memberDraft.birthPlace))
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
            isFirstNameFocused = member.firstName == nil || member.firstName!.isEmpty
        }
        .onDisappear {
            member.updateDetails(using: memberDraft)
        }
    }

    private func customBinding(for string: Binding<String?>) -> Binding<String> {
        Binding(get: { string.wrappedValue ?? "" }, set: { string.wrappedValue = $0.isEmpty ? nil : $0 })
    }
}
