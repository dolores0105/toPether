//
//  PetProvider.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/19.
//

import Firebase

class PetProvider {
    let dataBase = Firestore.firestore()
    var passPetDataClosure: ((_ petData: [Pet]) -> Void)?
    
    func setPetData() {
        let pets = Firestore.firestore().collection("pets")
        let document = pets.document()
        
        let pet = Pet(
            petId: document.documentID,
            petName: "Kesha",
            petGender: "male",
            birthday: NSDate().timeIntervalSince1970,
            photo: "https://i.epochtimes.com/assets/uploads/2021/08/id13156667-shutterstock_376153318-600x400.jpg",
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
}
