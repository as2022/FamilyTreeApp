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
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                isFocused = member.firstName.isEmpty
                            }
                        }
                TextField("Middle Name", text: Binding(get: { member.middleName ?? "" }, set: { member.middleName = $0.isEmpty ? nil : $0 }))
                TextField("Last Name", text: $member.lastName)
                TextField("Birthplace", text: $member.birthPlace)
                DatePicker("Birthdate", selection: $member.birthDate, displayedComponents: .date)
            }
            
            if enableRelationships {
                Section(header: Text("Family")) {
                    RelationshipPicker(
                        title: "Father",
                        options: allMembers,
                        selection:
                            Binding(
                                get: { member.father },
                                set: { father in
                                    if let father {
                                        update(father: father)
                                    }
                    }))
                    RelationshipPicker(
                        title: "Mother",
                        options: allMembers,
                        selection:
                            Binding(
                                get: { member.mother },
                                set: { mother in
                                    if let mother {
                                        update(mother: mother)
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

    func update(father: FamilyMember) {
        modelContext.insert(father)
        member.father = father
        member.siblings.forEach { $0.father = father }
    }

    func update(mother: FamilyMember) {
        modelContext.insert(mother)
        member.mother = mother
        member.siblings.forEach { $0.mother = mother }
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
