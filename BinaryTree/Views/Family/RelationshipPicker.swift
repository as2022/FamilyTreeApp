//
//  RelationshipPicker.swift
//  FamilyTree
//
//  Created by Alex Smithson on 3/1/25.
//
import SwiftUI

struct RelationshipPicker: View {

    @Environment(\.modelContext) private var modelContext
    @State private var newMember: FamilyMember?
    @State private var isPresentingDetail = false
    var title: String
    var options: [FamilyMember]
    @Binding var selection: FamilyMember?

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Picker(title, selection: $selection) {
                    Text("None").tag(nil as FamilyMember?)
                    ForEach(options, id: \ .id) { person in
                        Text(person.fullName).tag(person as FamilyMember?)
                    }
                }

                Button(action: {
                    let createdMember = FamilyMember(firstName: "", lastName: "", birthDate: Date(), birthPlace: "")
                    modelContext.insert(createdMember)
                    newMember = createdMember
                    isPresentingDetail = true
                }, label: {
                    Image(systemName: "person.fill.badge.plus")
                })
            }
            .sheet(item: $newMember) { newMember in
                NavigationStack {
                    FamilyMemberDetailView(member: newMember)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Cancel") {
                                    isPresentingDetail = false
                                    modelContext.delete(newMember)
                                }
                            }
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("Save") {
                                    selection = newMember
                                    isPresentingDetail = false
                                }
                            }
                        }
                    }
            }
            .buttonStyle(BorderlessButtonStyle())
            .foregroundColor(.blue)
        }
    }
}
