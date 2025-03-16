//
//  FamilyMemberView.swift
//  FamilyTree
//
//  Created by Alex Smithson on 3/1/25.
//

import SwiftUI

struct FamilyMemberView: View {
    var member: FamilyMember
    @State private var isDetailPresented = false
    
    var body: some View {
        VStack {
            Button(action: {
                isDetailPresented = true
            }) {
                VStack {
                    Text("\(member.firstName) \(member.lastName)")
                        .font(.headline)
                    Text("Born: \(formattedDate(member.birthDate))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)
            }
            .sheet(isPresented: $isDetailPresented) {
                NavigationStack {
                    FamilyMemberDetailView(member: member)
                }
            }
            
            if !member.children.isEmpty {
                HStack {
                    ForEach(member.children) { child in
                        FamilyMemberView(member: child)
                    }
                }
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
