//
//  ContentView.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/15/25.
//

import SwiftData
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ContentView: View {

    @Environment(\.modelContext) private var modelContext

    @Query private var allMembers: [FamilyMember]
    @Query private var allCrossBloodlineConnections: [CrossBloodlineConnection]

    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    uploadAllData()
                }) {
                    Text("Save to the Cloud")
                }
                MyTreesView()
            }
        }
    }

    func uploadAllData() {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        allMembers.forEach { member in
            let memberDTO = FamilyMemberDTO(clientModel: member)
            saveToFirebase(memberDTO, userID: userID)
        }
        allCrossBloodlineConnections.forEach { connection in
            saveToFirebase(connection, userID: userID)
        }
    }

    func saveToFirebase(_ member: FamilyMemberDTO, userID: String) {
        let db = Firestore.firestore()
        let path = db.collection("users")
            .document(userID)
            .collection("familyTree")
            .document(member.id.uuidString)

        do {
            try path.setData(from: member)
        } catch {
        }
    }

    func saveToFirebase(_ connection: CrossBloodlineConnection, userID: String) {
        let db = Firestore.firestore()
        let path = db.collection("users")
            .document(userID)
            .collection("crossBloodlineConnections")
            .document("\(connection.fromChild.uuidString)-\(connection.toNewParent.uuidString)")

        do {
            try path.setData(from: connection)
        } catch {
            print("❌ Failed to encode CrossBloodlineConnection: \(error)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
