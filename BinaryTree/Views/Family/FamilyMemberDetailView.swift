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
    var enableRelationships: Bool = true

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
            if enableRelationships {
                Section(header: Text("Family")) {
                    RelationshipPicker(
                        title: "Parent",
                        options: allMembers,
                        selection:
                            Binding(
                                get: { member.parent },
                                set: { parent in
                                    if let parent {
                                        update(parent: parent)
                                    }
                    }))
                    ForEach(member.siblings, id: \.id) { sibling in
                        RelationshipPicker(title: "Sibling", options: allMembers, selection: .constant(sibling))
                        .swipeActions(allowsFullSwipe: true) {
                            Button("Delete") {
                                member.siblings.removeAll { $0.id == sibling.id }
                            }
                        }
                    }

                    Button("Add New Sibling") {
                        let newSibling = FamilyMember(firstName: "", lastName: "", birthDate: Date(), birthPlace: "")
                        update(sibling: newSibling)
                    }
                }
            }
        }
        .navigationTitle(member.fullName)
    }

    func update(parent: FamilyMember) {
        member.parent = parent
        member.siblings.forEach { $0.parent = parent }
    }

    func update(sibling newSibling: FamilyMember) {
        modelContext.insert(newSibling)
        member.siblings.forEach { mySibling in
            if !mySibling.siblings.contains(where: { $0 == newSibling }) {
                mySibling.siblings.append(newSibling)
            }
        }
        member.siblings.append(newSibling)
    }
}
