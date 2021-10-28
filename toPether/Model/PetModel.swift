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
    
    func getYearMonth(from birthday: Date) -> (year: Int?, month: Int?) { // 當下載了Pet以後，Pet.birthday用這個取得目前的年月，供畫面顯示
        let calendar = Calendar.current
        let today = Date()
        let components = calendar.dateComponents([.year, .month], from: birthday, to: today)
        return (components.year, components.month)
    }
    
    func setPetData(name: String, gender: String, year: Int, month: Int, photo: UIImage, memberIds: [String], completion: @escaping (Result<String, Error>) -> Void) {
        guard let jpegData06 = photo.jpegData(compressionQuality: 0.2) else { return }
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
            completion(Result.success(pet.id))
            print(pet)
        } catch let error {
            print("set pet data error:", error)
            completion(Result.failure(error))
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
    
    // MARK: update
    func updatePet(id: String, pet: Pet) {
        do {
            try dataBase.collection("pets").document(id).setData(from: pet)
            print("update pet:", pet.id)
        } catch {
            print("update error", error)
        }
    }
    
    func addPetListener(pet: Pet, completion: @escaping (Result<Pet, Error>) -> Void) -> ListenerRegistration {
        dataBase.collection("pets").document(pet.id).addSnapshotListener { documentSnapshot, error in
            if let pet = try? documentSnapshot?.data(as: Pet.self) {
                completion(.success(pet))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    /* ---------------------Medical---------------------------- */
    // MARK: Medical
    func setMedical(petId: String, symptoms: String, dateOfVisit: Date, clinic: String, vetOrder: String, completion: @escaping (Result<Medical, Error>) -> Void) {
        
        let medicals = Firestore.firestore().collection("pets").document(petId).collection("medicals")
        let document = medicals.document()
        
        let medicalRecord = Medical()
        medicalRecord.id = document.documentID
        medicalRecord.symptoms = symptoms
        medicalRecord.dateOfVisit = dateOfVisit
        medicalRecord.clinic = clinic
        medicalRecord.vetOrder = vetOrder
        
        do {
            try document.setData(from: medicalRecord)
            completion(Result.success(medicalRecord))
        } catch let error {
            print("set medicalRecord error:", error)
            completion(Result.failure(error))
        }
    }
    
    func queryMedicals(petId: String, completion: @escaping (Result<[Medical], Error>) -> Void) {
        dataBase.collection("pets").document(petId).collection("medicals").order(by: "dateOfVisit", descending: true).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                
                let medicals = querySnapshot.documents.compactMap({ querySnapshot in
                    try? querySnapshot.data(as: Medical.self)
                })
                completion(Result.success(medicals))
                
            } else if let error = error {
                completion(Result.failure(error))
            }
        }
    }
    
    func updateMedical(petId: String, recordId: String, medical: Medical) { // completion
        do {
            try dataBase.collection("pets").document(petId).collection("medicals").document(recordId).setData(from: medical)
            print("update medical:", medical.id)
        } catch {
            print("update medical error", error)
        }
    }
    
    func deleteMedical(petId: String, recordId: String) { // completion
        dataBase.collection("pets").document(petId).collection("medicals").document(recordId).delete() { error in
            if let error = error {
                print("Error removing medical document: \(error)")
            } else {
                print("removed", recordId)
            }
        }
    }
    
    func addMedicalListener(petId: String, recordId: String, completion: @escaping (Result<Medical, Error>) -> Void) -> ListenerRegistration {
        dataBase.collection("pets").document(petId).collection("medicals").document(recordId).addSnapshotListener { documentSnapshot, error in
            if let medical = try? documentSnapshot?.data(as: Medical.self) {
                completion(.success(medical))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}
