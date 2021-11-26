//
//  MemberManager.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/21.
//

import Firebase

enum ListenerType<T> {
    case added(data: T)
    case modified(data: T)
    case removed(data: T)
}

class MemberManager {
    
    private init() {}
    static let shared = MemberManager()
    
    let dataBase = Firestore.firestore().collection("members")
    var current: Member? // set value at splash page
    
    // MARK: - Create
    
    func setMember(uid: String, name: String?, completion: @escaping (Result<(Member, Bool), Error>) -> Void) {
        let document = dataBase.document(uid)
        
        let member = Member()
        member.id = uid
        member.name = name ?? ""
        member.petIds = []

        // for distinguishing to emptySetting process or to home page directly
        checkUserExists(uid: uid) { isExist in
            if !isExist {
                do {
                    try document.setData(from: member)
                    completion(.success((member, false))) // user not exist
                } catch let error {
                    completion(.failure(error))
                }
            } else {
                completion(.success((member, true))) // user exists in firebase auth
            }
        }
    }
    
    func checkUserExists(uid: String, isExist: @escaping (Bool) -> Void) {
        dataBase.document(uid).getDocument { document, _ in
            if let document = document {
                if document.exists {
                    isExist(true)
                } else {
                    isExist(false)
                }
            } else {
                isExist(false)
            }
        }
    }
    
    // MARK: - Query
    
    // Use memberId to fetch current user's information
    func queryCurrentUser(id: String, completion: @escaping (Result<Member, Error>) -> Void) {
        dataBase.document(id).getDocument { (querySnapshot, error) in
            if let member = try? querySnapshot?.data(as: Member.self) {
                completion(.success(member))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    // Use memberIds array of a pet's data to query members data that owned those pets
    func queryMembers(ids: [String], completion: @escaping (Result<[Member], Error>) -> Void) {
        dataBase.whereField(FieldPath.documentID(), in: ids).getDocuments { (querySnapshot, error) in
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
    
    // Use memberId to query a single member's data
    func queryMember(id: String, completion: @escaping (Member?) -> Void) {
        dataBase.document(id).getDocument { (querySnapshot, error) in
            if let member = try? querySnapshot?.data(as: Member.self) {
                completion(member)
            } else {
                completion(nil)
            }
        }
    }
    
    // MARK: - update
    
    func updateCurrentUser() {
        guard let user = current else { return }
        do {
            try dataBase.document(user.id).setData(from: user)
        } catch {
            print(error)
        }
    }
    
    func updateMember(member: Member) {
        do {
            try dataBase.document(member.id).setData(from: member)
        } catch {
            print(error)
        }
    }
    
    // MARK: - Listener
    
    func addUserListener(completion: @escaping (Result<ListenerType<Member>, Error>) -> Void) {
        guard let user = current else { return }
        dataBase.whereField("id", isEqualTo: user.id).addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }
            
            if let querySnapshot = querySnapshot {
                
                let members = querySnapshot.documents.compactMap({ querySnapshot in
                    try? querySnapshot.data(as: Member.self)
                })
                
                guard let currentUser = members.first else { return }
                self.current = currentUser
                
                querySnapshot.documentChanges.forEach { diff in
                    switch diff.type {
                    case .added:
                        print("add")
                        completion(.success(.added(data: currentUser)))
                        
                    case .modified:
                        print("modifi")
                        completion(.success(.modified(data: currentUser)))
                    case .removed:
                        print("remove")
                        completion(.success(.removed(data: currentUser)))
                    }
                }
                
            } else if let error = error {
                completion(Result.failure(error))
            }
        }
    }
}
