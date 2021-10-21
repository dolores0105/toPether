//
//  MemberModel.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/21.
//

import Firebase

class MemberModel {
    let dataBase = Firestore.firestore()
    
    // MARK: SetData
    func setMember() {
        let members = Firestore.firestore().collection("members")
        let document = members.document()
        
        let member = Member(
            memberId: document.documentID,
            memberName: "Dodo",
            pets: ["E5ebgGOiKj8uQC7UgLKK", "BfaFAFa8avMTjnUEnuOK"],
            qrCode: document.documentID
        )
        
        do {
            try document.setData(from: member)
        } catch let error {
            print("set pet data error:", error)
        }
    }
    
    // MARK: Query members
    // 1: Use memberId to fetch current user's information
    func queryCurrentUser(id: String, completion: @escaping (Result<[Member], Error>) -> Void) {
        dataBase.collection("members").whereField("memberId", isEqualTo: id).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                
                let member = querySnapshot.documents.compactMap({ querySnapshot in
                    try? querySnapshot.data(as: Member.self)
                })
                completion(Result.success(member))
                
            }
            
            if let error = error {
                completion(Result.failure(error))
            }
        }
    }
    
    
    // 2: Use memberIds array of a pet's data to query members data that owned those pets
    func queryMembers(ids: [String], completion: @escaping (Result<[Member], Error>) -> Void) {
        dataBase.collection("members").whereField("memberId", in: ids).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                
                let members = querySnapshot.documents.compactMap({ querySnapshot in
                    try? querySnapshot.data(as: Member.self)
                })
                completion(Result.success(members))
                
            }
            
            if let error = error {
                completion(Result.failure(error))
            }
        }
    }
}
