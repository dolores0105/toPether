//
//  MemberModel.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/21.
//

import Firebase

class MemberModel {
    
    private init() {}
    static let shared = MemberModel()
    
    let dataBase = Firestore.firestore()
    var current: Member?
    
    // MARK: SetData
    func setMember() {
        let members = Firestore.firestore().collection("members")
        let document = members.document()
        
        let member = Member()
        member.id = document.documentID
        member.name = "Dodo"
        member.petIds = ["E5ebgGOiKj8uQC7UgLKK", "BfaFAFa8avMTjnUEnuOK"]
        member.qrCode = document.documentID

        
        do {
            try document.setData(from: member)
        } catch {
            print("set pet data error:", error)
        }
    }
    
    // MARK: Query members
    // 1: Use memberId to fetch current user's information
    func queryCurrentUser(id: String, completion: @escaping (Result<Member, Error>) -> Void) {
        dataBase.collection("members").document(id).getDocument { (querySnapshot, error) in
            if let member = try? querySnapshot?.data(as: Member.self) {
                completion(.success(member))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    // 2: Use memberIds array of a pet's data to query members data that owned those pets
    func queryMembers(ids: [String], completion: @escaping (Result<[Member], Error>) -> Void) {
        dataBase.collection("members").whereField(FieldPath.documentID(), in: ids).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                
                let members = querySnapshot.documents.compactMap({ querySnapshot in
                    try? querySnapshot.data(as: Member.self)
                })
                completion(Result.success(members))
                
            } else if let error = error {
                completion(Result.failure(error))
            }
        }
    }
    
    // MARK: update
    func updateCurrentUser() {
        guard let user = current else { return }
        print(current?.name)
        do {
            try dataBase.collection("members").document(user.id).setData(from: user)
        } catch {
            print(error)
        }
//        let batch = dataBase.batch()
//        let member = dataBase.collection("members").document(documentId)
//        batch.updateData(["memberName": updatedName], forDocument: member)
//
//        batch.commit { error in
//            if let error = error {
//                print("Error writing batch \(error)")
//            } else {
//                print("Update member name succeeded")
//            }
//        }
    }
    
    // MARK: delete
    func deletePet(petId: String) { // 不要這個了
        guard let id = current?.id else { return }
//        let batch = dataBase.batch()
//        let member = dataBase.collection("members").document(documentId)
//        batch.updateData(["pets": petIds], forDocument: member)
//
//        batch.commit { error in
//            if let error = error {
//                print("Error writing batch \(error)")
//            } else {
//                print("Update deleting pet succeeded")
//            }
//        }
    }
}
