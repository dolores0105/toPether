//
//  ToDoManager.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/8.
//

import Firebase
import Foundation

class ToDoManager {
    
    private init() {}
    static let shared = ToDoManager()
    
    let dataBase = Firestore.firestore()
    
    func setToDo(creatorId: String, executorId: String, petId: String, dueTime: Date, content: String, completion: @escaping (Result<ToDo, Error>) -> Void) {
        let todos = dataBase.collection("todos")
        let document = todos.document()
        
        let todo = ToDo()
        todo.id = document.documentID
        todo.creatorId = creatorId
        todo.executorId = executorId
        todo.petId = petId
        todo.dueTime = dueTime
        todo.content = content
        todo.doneStatus = false
        
        do {
            try document.setData(from: todo)
            completion(.success(todo))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func queryToDos(petIds: [String], completion: @escaping (Result<[ToDo], Error>) -> Void) {
        
        guard !petIds.isEmpty else { // if petIds is an empty array
            completion(Result.failure(CommonError.emptyArrayInFilter))
            return
        }
        
        dataBase.collection("todos").whereField("petId", in: petIds).getDocuments { (querySnapshot, error) in
            
            if let querySnapshot = querySnapshot {
                let todos = querySnapshot.documents.compactMap({ querySnapshot in
                    try? querySnapshot.data(as: ToDo.self)
                })
                let sortedToDos = todos.sorted { $0.dueTime > $1.dueTime }
                completion(.success(sortedToDos))
                
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func addToDosListener(petIds: [String], completion: @escaping (Result<[ToDo], Error>) -> Void) {
        
        guard !petIds.isEmpty else { // if petIds is an empty array
            completion(Result.failure(CommonError.emptyArrayInFilter))
            return
        }
        
        dataBase.collection("todos").whereField("petId", in: petIds).addSnapshotListener { (querySnapshot, error) in
            
            if let querySnapshot = querySnapshot {
                let todos = querySnapshot.documents.compactMap({ querySnapshot in
                    try? querySnapshot.data(as: ToDo.self)
                })
                let sortedToDos = todos.sorted { $0.dueTime > $1.dueTime }
                completion(.success(sortedToDos))
                
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}