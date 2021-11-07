//
//  PetModel.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/19.
// swiftlint:disable function_parameter_count

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

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

        guard !ids.isEmpty else { // if ids is an empty array
            completion(Result.failure(CommonError.emptyArrayInFilter))
            return
        }
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
    
    func addMedicalsListener(petId: String, completion: @escaping (Result<[Medical], Error>) -> Void) {
        dataBase.collection("pets").document(petId).collection("medicals").addSnapshotListener { querySnapshot, error in
            
            if let querySnapshot = querySnapshot {
                let medicals = querySnapshot.documents.compactMap({ querySnapshot in
                    try? querySnapshot.data(as: Medical.self)
                })
                let sortedmedicals = medicals.sorted { $0.dateOfVisit > $1.dateOfVisit }
                completion(.success(sortedmedicals))
                
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    /* ---------------------Food---------------------------- */
    // MARK: Food
    func setFood(petId: String, name: String, weight: String, unit: String, price: String, market: String, dateOfPurchase: Date, note: String, completion: @escaping (Result<Food, Error>) -> Void) {
        
        let foods = Firestore.firestore().collection("pets").document(petId).collection("foods")
        let document = foods.document()
        
        let foodRecord = Food()
        foodRecord.id = document.documentID
        foodRecord.name = name
        foodRecord.weight = weight
        foodRecord.unit = unit
        foodRecord.price = price
        foodRecord.market = market
        foodRecord.dateOfPurchase = dateOfPurchase
        foodRecord.note = note
        
        do {
            try document.setData(from: foodRecord)
            completion(Result.success(foodRecord))
        } catch let error {
            print("set foodRecord error:", error)
            completion(Result.failure(error))
        }
    }
    
    func queryFoods(petId: String, completion: @escaping (Result<[Food], Error>) -> Void) {
        
        dataBase.collection("pets").document(petId).collection("foods").order(by: "dateOfPurchase", descending: true).getDocuments { (querySnapshot, error) in
            
            if let querySnapshot = querySnapshot {
                
                let foods = querySnapshot.documents.compactMap({ querySnapshot in
                    try? querySnapshot.data(as: Food.self)
                })
                completion(Result.success(foods))
                
            } else if let error = error {
                completion(Result.failure(error))
            }
        }
    }
    
    func updateFood(petId: String, recordId: String, food: Food) {
        do {
            try dataBase.collection("pets").document(petId).collection("foods").document(recordId).setData(from: food)
            print("update food:", food.id)
        } catch {
            print("update food error", error)
        }
    }
    
    func deleteFood(petId: String, recordId: String) {
        dataBase.collection("pets").document(petId).collection("foods").document(recordId).delete() {
            error in
            if let error = error {
                print("Error removing food document: \(error)")
            } else {
                print("removed food", recordId)
            }
        }
    }
    
    func addFoodsListener(petId: String, completion: @escaping (Result<[Food], Error>) -> Void) {
        dataBase.collection("pets").document(petId).collection("foods").addSnapshotListener { querySnapshot, error in
            
            if let querySnapshot = querySnapshot {
                let foods = querySnapshot.documents.compactMap({ querySnapshot in
                    try? querySnapshot.data(as: Food.self)
                })
                
                let sortedfoods = foods.sorted { $0.dateOfPurchase > $1.dateOfPurchase }
                completion(.success(sortedfoods))
                
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    /* ---------------------Message---------------------------- */
    // MARK: Message
    func setMessage(petId: String, senderId: String, sentTime: Date, content: String, completion: @escaping (Result<Message, Error>) -> Void) {
        
        let messages = Firestore.firestore().collection("pets").document(petId).collection("messages")
        let document = messages.document()
        
        let message = Message()
        message.id = document.documentID
        message.senderId = senderId
        message.sentTime = sentTime
        message.content = content
        
        do {
            try document.setData(from: message)
            completion(Result.success(message))
        } catch let error {
            print("set message error:", error)
            completion(Result.failure(error))
        }
    }
    
    func queryMessages(petId: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        dataBase.collection("pets").document(petId).collection("messages").order(by: "sentTime", descending: false).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                
                let messages = querySnapshot.documents.compactMap({ querySnapshot in
                    try? querySnapshot.data(as: Message.self)
                })
                completion(Result.success(messages))
                
            } else if let error = error {
                completion(Result.failure(error))
            }
        }
    }
    
    func addMessagesListener(petId: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        dataBase.collection("pets").document(petId).collection("messages").addSnapshotListener { querySnapshot, error in
            
            if let querySnapshot = querySnapshot {
                let messages = querySnapshot.documents.compactMap({ querySnapshot in
                    try? querySnapshot.data(as: Message.self)
                })
                let sortedmessages = messages.sorted { $0.sentTime < $1.sentTime }
                completion(.success(sortedmessages))
                
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}
