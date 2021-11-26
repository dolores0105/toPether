//
//  PetManager.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/19.

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

enum PetObjectType {
    case food
    case medical
}

class PetManager {
    
    private init() {}
    static let shared = PetManager()
    
    let dataBase = Firestore.firestore().collection("pets")
    
    // MARK: - pet
    
    func getBirthday(year: Int, month: Int) -> Date? {
        let calendar = Calendar.current
        let today = Date()
        return calendar.date(byAdding: DateComponents(year: -year, month: -month), to: today)
    }
    
    func getYearMonth(from birthday: Date) -> (year: Int?, month: Int?) {
        let calendar = Calendar.current
        let today = Date()
        let components = calendar.dateComponents([.year, .month], from: birthday, to: today)
        return (components.year, components.month)
    }
    
    func setPetData(pet: Pet, photo: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let jpegData06 = photo.jpegData(compressionQuality: 0.2) else { return }
        let imageBase64String = jpegData06.base64EncodedString()
        
        let document = dataBase.document()
        
        pet.id = document.documentID
        pet.photo = imageBase64String
        
        do {
            try document.setData(from: pet)
            completion(.success(pet.id))

        } catch let error {

            completion(.failure(error))
        }
    }
    
    // Use petIds array of a members data to query pets data that is owned by that member
    func queryPets(ids: [String], completion: @escaping (Result<[Pet], Error>) -> Void) {

        guard !ids.isEmpty else {
            completion(.failure(CommonError.emptyArrayInFilter))
            return
        }
        dataBase.whereField(FieldPath.documentID(), in: ids).order(by: FieldPath.documentID()).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                
                let pets = querySnapshot.documents.compactMap({ querySnapshot in
                    try? querySnapshot.data(as: Pet.self)
                })
                completion(.success(pets.sorted(by: ids)))
                
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func queryPet(id: String, completion: @escaping (Result<Pet, Error>) -> Void) {
        dataBase.document(id).getDocument { (querySnapshot, error) in
            
            if let error = error {
                completion(.failure(error))
            }
            
            if let pet = try? querySnapshot?.data(as: Pet.self) {
                completion(.success(pet))
            }
        }
    }
    
    // modify pet info or remove member from pet
    func updatePet(id: String, pet: Pet, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            try dataBase.document(id).setData(from: pet)
            completion(.success("update pet: \(pet.id)"))
        } catch {
            completion(.failure(error))
        }
    }

    func addPetListener(pet: Pet, completion: @escaping (Result<Pet, Error>) -> Void) -> ListenerRegistration {
        dataBase.document(pet.id).addSnapshotListener { documentSnapshot, error in
            if let pet = try? documentSnapshot?.data(as: Pet.self) {
                completion(.success(pet))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Medical
    
    func setMedical(petId: String, medical: Medical, completion: @escaping (Result<String, Error>) -> Void) {
        
        let medicals = dataBase.document(petId).collection("medicals")
        let document = medicals.document()
        
        medical.id = document.documentID
        
        do {
            try document.setData(from: medical)
            completion(.success(medical.id))
        } catch let error {
            print("set medicalRecord error:", error)
            completion(.failure(error))
        }
    }
    
    func queryMedicals(petId: String, completion: @escaping (Result<[Medical], Error>) -> Void) {
        dataBase.document(petId).collection("medicals").order(by: "dateOfVisit", descending: true).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                
                let medicals = querySnapshot.documents.compactMap({ querySnapshot in
                    try? querySnapshot.data(as: Medical.self)
                })
                completion(.success(medicals))
                
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func addMedicalsListener(petId: String, completion: @escaping (Result<[Medical], Error>) -> Void) {
        dataBase.document(petId).collection("medicals").addSnapshotListener { querySnapshot, error in
            
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
    
    // MARK: - Food
    func setFood(petId: String, food: Food, completion: @escaping (Result<String, Error>) -> Void) {
        
        let foods = dataBase.document(petId).collection("foods")
        let document = foods.document()
        
        food.id = document.documentID

        do {
            try document.setData(from: food)
            completion(.success("set food \(food.id)"))
        } catch let error {
            print("set foodRecord error:", error)
            completion(.failure(error))
        }
    }
    
    func queryFoods(petId: String, completion: @escaping (Result<[Food], Error>) -> Void) {
        
        dataBase.document(petId).collection("foods").order(by: "dateOfPurchase", descending: true).getDocuments { (querySnapshot, error) in
            
            if let querySnapshot = querySnapshot {
                
                let foods = querySnapshot.documents.compactMap({ querySnapshot in
                    try? querySnapshot.data(as: Food.self)
                })
                completion(.success(foods))
                
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }

    func addFoodsListener(petId: String, completion: @escaping (Result<[Food], Error>) -> Void) {
        dataBase.document(petId).collection("foods").addSnapshotListener { querySnapshot, error in
            
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
    
    // MARK: - Message
    
    func setMessage(petId: String, message: Message, completion: @escaping (Result<Message, Error>) -> Void) {
        
        let messages = dataBase.document(petId).collection("messages")
        let document = messages.document()

        message.id = document.documentID

        do {
            try document.setData(from: message)
            completion(.success(message))
        } catch let error {
            print("set message error:", error)
            completion(.failure(error))
        }
    }
    
    func queryMessages(petId: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        dataBase.document(petId).collection("messages").order(by: "sentTime", descending: false).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                
                let messages = querySnapshot.documents.compactMap({ querySnapshot in
                    try? querySnapshot.data(as: Message.self)
                })
                completion(.success(messages))
                
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func addMessagesListener(petId: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        dataBase.document(petId).collection("messages").addSnapshotListener { querySnapshot, error in
            
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
    
    // MARK: - General functions
    // PetObjectType + associated value
    func updatePetObject<T: Codable>(petId: String, recordId: String, objectType: PetObjectType, object: T, completion:  @escaping (Result<String, Error>) -> Void) {
        
        let documentRef: DocumentReference?
        
        switch objectType {
        case .food:
            documentRef = dataBase.document(petId).collection("foods").document(recordId)
        case .medical:
            documentRef = dataBase.document(petId).collection("medicals").document(recordId)
        }
        
        do {
            guard let documentRef = documentRef else { return }
            try documentRef.setData(from: object)
            
            completion(.success("updated pet \(petId)'s  \(recordId)"))
            
        } catch {
            completion(.failure(error))
        }
    }
    
    // todo
    func deletePetObject(petId: String, recordId: String, objectType: PetObjectType, completion:  @escaping (Result<String, Error>) -> Void) {
        
        let documentRef: DocumentReference?
        
        switch objectType {
        case .food:
            documentRef = dataBase.document(petId).collection("foods").document(recordId)
        case .medical:
            documentRef = dataBase.document(petId).collection("medicals").document(recordId)
        }
        
        guard let documentRef = documentRef else { return }
        documentRef.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success("deleted pet \(petId)'s  \(recordId)"))
            }
        }
    }
}
