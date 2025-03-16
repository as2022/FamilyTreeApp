//
//  Untitled.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/15/25.
//

import SwiftData
import SwiftUI

struct BinaryTreeView: View {

    @Environment(\.modelContext) private var modelContext
    @Query private var familyMemberRoot: FamilyMember
    @State private var isAddingMember = false
    @State private var newMember = FamilyMember(firstName: "", lastName: "", birthDate: Date(), birthPlace: "")

       var body: some View {
           NavigationStack {
               Diagram(tree: familyMemberRoot, node: { value in
                   Text("\(value.value)")
                       .modifier(RoundedCircleStyle())
               })
               .navigationTitle("Family Tree")
               .toolbar {
                   ToolbarItem(placement: .topBarTrailing) {
                       Button(action: {
                           newMember = FamilyMember(firstName: "", lastName: "", birthDate: Date(), birthPlace: "")
                           isAddingMember = true
                       }) {
                           Label("Add", systemImage: "plus")
                       }
                   }
               }
               .sheet(isPresented: $isAddingMember) {
                   NavigationStack {
                       FamilyMemberDetailView(member: newMember)
                           .toolbar {
                               ToolbarItem(placement: .topBarLeading) {
                                   Button("Cancel") {
                                       isAddingMember = false
                                   }
                               }
                               ToolbarItem(placement: .topBarTrailing) {
                                   Button("Save") {
                                       modelContext.insert(newMember)
                                       try? modelContext.save()
                                       isAddingMember = false
                                   }
                               }
                           }
                   }
               }
           }
       }

    func getRandomFullName() -> String {
        let firstNames = ["Liam", "Olivia", "Noah", "Emma", "Oliver", "Ava", "Alexander", "Sophia", "Drew", "Isabella"]
        let lastNames = ["Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia"]
        return "\(firstNames.randomElement() ?? "John") \(lastNames.randomElement() ?? "Doe")"
    }
}

struct RoundedCircleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 80, height: 80)
            .background(Circle().stroke())
            .background(Circle().fill(Color.white))
            .padding(10)
    }
}
