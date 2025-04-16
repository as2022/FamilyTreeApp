//
//  LoadingAppViewModel.swift
//  BinaryTree
//
//  Created by Alex Smithson on 4/16/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftData

@MainActor
class LoadingAppViewModel: ObservableObject {

    var user: User
    @Published var appDataLoaded = false
    @Published var proceedToApp = false

    // MARK: Considering making new type called tree-graph-loader-view
    // Here are the types for it:

    var parentsInConnections: [FamilyMember] = []
    var chilrenInConnections: [FamilyMember] = []

    init(user: User) {
        self.user = user
    }

    func loadAppData(_ modelContext: ModelContext) async {
        await fetchAppData(for: user.uid, modelContext: modelContext)
        appDataLoaded = true
        // Delay and proceed after loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.proceedToApp = true
        }
    }

    private func fetchAppData(for userID: String, modelContext: ModelContext) async {
        let db = Firestore.firestore()

        // Fetch Cross-Bloodline Connections
        let connectionSnapshot = try? await db.collection("users")
            .document(userID)
            .collection("crossBloodlineConnections")
            .getDocuments()

        var decodedConnections: [CrossBloodlineConnection] = []
        if let connectionDocs = connectionSnapshot?.documents {
            for doc in connectionDocs {
                if let connection = try? doc.data(as: CrossBloodlineConnection.self) {
                    decodedConnections.append(connection)
                }
            }
        }

        // Fetch Family Members
        let familySnapshot = try? await db.collection("users")
            .document(userID)
            .collection("familyTree")
            .getDocuments()

        guard let familyDocs = familySnapshot?.documents else { return }

        var decodedFamilyMembers: [FamilyMemberDTO] = []
        for doc in familyDocs {
            if let member = try? doc.data(as: FamilyMemberDTO.self) {
                decodedFamilyMembers.append(member)
            }
        }

        decodedFamilyMembers
            .filter { $0.isTopOfBloodline }
            .compactMap { root in
                createObjectGraph(for: root, given: decodedFamilyMembers)
            }
            .forEach {
                modelContext.insert($0)
            }

        decodedConnections.forEach { connection in
            let connectionChild = chilrenInConnections.first(where: { $0.id == connection.fromChild })
            let connectionParent = parentsInConnections.first(where: { $0.id == connection.toNewParent })
    
            connectionChild?.parent = connectionParent
            connectionParent?.bloodlineConnectionChild = connectionChild
            modelContext.insert(connection)
        }
    }

    private func createObjectGraph(
        for dtoMember: FamilyMemberDTO,
        knowing parent: FamilyMember? = nil,
        given allDTOs: [FamilyMemberDTO]
    ) -> FamilyMember? {

        // Create base without any relationships
        let runningFamilyMember = FamilyMember(dto: dtoMember)

        // Add relationships to children
        runningFamilyMember.children = dtoMember.childrenIds
            .compactMap { dtoChildId in
                if let dtoChild = allDTOs.first(where: { $0.id == dtoChildId }) {
                    // Removing familyMembers from allDTOs that can't possibly be matches should expedite the algorithm.
                    createObjectGraph(for: dtoChild, given: allDTOs.filter { $0.id != dtoChildId && $0.id != dtoMember.id })
                } else {
                    nil
                }
            }

        // Add relationship to spouse
        runningFamilyMember.spouse = if let memberSpouseDTO = allDTOs.first(where: { $0.id == dtoMember.spouseId }) {
            // Removing familyMembers from allDTOs that can't possibly be matches should expedite the algorithm.
            createObjectGraph(for: memberSpouseDTO, given: allDTOs.filter { $0.id != dtoMember.spouseId && $0.id != dtoMember.id })
        } else {
            nil
        }

        // Add relationship to parent
        runningFamilyMember.parent = parent

        if dtoMember.connectsTwoBloodlines {
            // TODO: this assumes that a user will never draw a connection line from a spouse to a spouse. Which is HIGHLY UNSAFE.
            // This needs addressed so that either
            // A) users CANNOT draw lines like this.
            // B) There is a new type of FamilyMemberView called FamilyNodeView, that will be treated as a married couple when referenced by children, and treated as individuals when referenced by its parents.
            if dtoMember.isMarriedIntoFamily {
                chilrenInConnections.append(runningFamilyMember)
            } else {
                parentsInConnections.append(runningFamilyMember)
            }
        }

        return runningFamilyMember
    }
}
