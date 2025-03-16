//
//  Untitled.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/15/25.
//

import SwiftData
import SwiftUI

struct BinaryTreeView: View {

    @State var tree = uniquePersonTree

    var body: some View {
        VStack {
            Text("Family Tree")
                .font(.headline)
            Spacer()
            Button(action: {
                withAnimation(.default) {
                    let person = FamilyMember(firstName: "", lastName: "", birthDate: Date(), birthPlace: "")
                    tree.insert(person)
                }
            }, label: { Text("Add person") })
            Spacer()
            Diagram(tree: tree, node: { value in
                FamilyMemberView(member: value.value)
            })
        }
    }
}
