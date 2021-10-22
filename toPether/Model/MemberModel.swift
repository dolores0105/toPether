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
    var current: Member? // set value at splash page
    
    // MARK: SetData
    func setMember(name: String) {
        let members = Firestore.firestore().collection("members")
        let document = members.document()
        
        let member = Member()
        member.id = document.documentID
        member.name = name
        member.petIds = []
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
        do {
            try dataBase.collection("members").document(user.id).setData(from: user)
        } catch {
            print(error)
        }
    }
    
    func addUserListener(completion: @escaping (Result<Member, Error>) -> Void) {
        guard let user = current else { return }
        dataBase.collection("members").document(user.id).addSnapshotListener { documentSnapshot, error in
            if let member = try? documentSnapshot?.data(as: Member.self) {
                completion(.success(member))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}
