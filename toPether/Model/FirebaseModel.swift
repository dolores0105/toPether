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
    
    // MARK: pet
    func getBirthday(year: Int, month: Int) -> Date? { // 當使用者選完了寵物的年月，用這個去得到生日，記在Pet裡
        let calendar = Calendar.current
        let today = Date()
        return calendar.date(byAdding: DateComponents(year: -year, month: -month), to: today)
    }

    func setPetData(name: String, gender: String, year: Int, month: Int, photo: UIImage, memberId: [String] = ["HSCnG2TeFczYF3404Mq7"]) {
        guard let jpegData06 = photo.jpegData(compressionQuality: 0.6) else { return }
        let imageBase64String = jpegData06.base64EncodedString()
        
        guard let birthday = getBirthday(year: year, month: month) else { return }
        
        let pets = Firestore.firestore().collection("pets")
        let document = pets.document()
        
        let pet = Pet(
            petId: document.documentID,
            petName: name,
            petGender: gender,
            birthday: birthday,
            photo: imageBase64String,
            groupMembersId: memberId
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
