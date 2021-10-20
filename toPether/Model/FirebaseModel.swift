//
//  FirebaseModel.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/19.
//

import Firebase

class FirebaseModel {
    let dataBase = Firestore.firestore()

    var members: [Member]?
    
    func setPetData() {
        let image = Img.iconsHomeSelected.obj
        guard let jpegData06 = image.jpegData(compressionQuality: 0.6) else { return }
        let imageBase64String = jpegData06.base64EncodedString()
        
        let pets = Firestore.firestore().collection("pets")
        let document = pets.document()
        
        let pet = Pet(
            petId: document.documentID,
            petName: "Kesha",
            petGender: "female",
            birthday: Date(),
            photo: imageBase64String,
            groupMembersId: ["HSCnG2TeFczYF3404Mq7"]
        )
        
        do {
            try document.setData(from: pet)
        } catch let error {
            print("set pet data error:", error)
        }
    }
    
    func fetchPetData(completion: @escaping (Result<[Pet], Error>) -> Void) {

        dataBase.collection("pets").getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                
                let pets = querySnapshot.documents.compactMap({ querySnapshot in
                    try? querySnapshot.data(as: Pet.self)
                })
                completion(Result.success(pets))
            }
            
            if let error = error {
                completion(Result.failure(error))
            }
        }
    }
    
    // MARK: Member
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
    
    func queryMembers(ids: [String], completion: @escaping (Result<[Member], Error>) -> Void) {
        dataBase.collection("members").whereField("memberId", in: ids).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                
                let members = querySnapshot.documents.compactMap({ querySnapshot in
                    try? querySnapshot.data(as: Member.self)
                })
                completion(Result.success(members))
                
//                print("queryMembers:", members)
//                print("count:", members.count)
            }
            
            if let error = error {
                completion(Result.failure(error))
            }
        }
    }
}
