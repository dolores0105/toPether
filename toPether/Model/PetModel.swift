//
//  PetModel.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/19.
//

import Firebase

class PetModel {
    
    private init() {}
    static let shared = PetModel()
    
    let dataBase = Firestore.firestore()
    
    // MARK: pet
    func getBirthday(year: Int, month: Int) -> Date? { // 當使用者選完了寵物的年月，用這個去得到生日，記在Pet裡
        let calendar = Calendar.current
        let today = Date()
        return calendar.date(byAdding: DateComponents(year: -year, month: -month), to: today)
    }

    func setPetData(name: String, gender: String, year: Int, month: Int, photo: UIImage, memberIds: [String]) {
        guard let jpegData06 = photo.jpegData(compressionQuality: 0.6) else { return }
        let imageBase64String = jpegData06.base64EncodedString()
        
        guard let birthday = getBirthday(year: year, month: month) else { return }
        
        let pets = Firestore.firestore().collection("pets")
        let document = pets.document()
        
        let pet = Pet()
        pet.id = document.documentID
        pet.name = name
        pet.gender = gender
        pet.birthday = birthday
        pet.photo = imageBase64String
        pet.memberIds = memberIds
        
        do {
            try document.setData(from: pet)
            print("Create a pet succee")
        } catch let error {
            print("set pet data error:", error)
        }
    }
    
    // MARK: Query pets
    // Use petIds array of a members data to query pets data that is owned by that member
    func queryPets(ids: [String], completion: @escaping (Result<[Pet], Error>) -> Void) {
        dataBase.collection("pets").whereField(FieldPath.documentID(), in: ids).order(by: FieldPath.documentID()).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                
                let pets = querySnapshot.documents.compactMap({ querySnapshot in
                    try? querySnapshot.data(as: Pet.self)
                })
                completion(Result.success(pets.sorted(by: ids)))
                
            } else if let error = error {
                completion(Result.failure(error))
            }
        }
    }
}
