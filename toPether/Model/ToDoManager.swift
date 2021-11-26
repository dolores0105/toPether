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
    
    let dataBase = Firestore.firestore().collection("todos")
    
    // MARK: - Create
    
    func setToDo(todo: ToDo, completion: @escaping (Result<String, Error>) -> Void) {
        let document = dataBase.document()
        
        todo.id = document.documentID
        todo.doneStatus = false
        
        do {
            try document.setData(from: todo)
            completion(.success("set new todo: \(todo.id)"))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func updateToDo(todo: ToDo, completion: (ToDo?) -> Void) {
        do {
            try dataBase.document(todo.id).setData(from: todo)
            completion(todo)
        } catch {
            print("update todo error", error)
            completion(nil)
        }
    }
    
    func deleteToDo(id: String, completion: @escaping(Bool) -> Void) {
        dataBase.document(id).delete { error in
            if let error = error {
                print("delete todo error", error)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    // MARK: - Listener
    
    func addToDosListenerOnDate(petIds: [String], date: Date, completion: @escaping (Result<[ToDo], Error>) -> Void) -> ListenerRegistration? {
        
        guard !petIds.isEmpty else {
            completion(Result.failure(CommonError.emptyArrayInFilter))
            return nil
        }
        
        let listener = dataBase.whereField("petId", in: petIds).addSnapshotListener { (querySnapshot, error) in
            
            if let querySnapshot = querySnapshot {
                let todos = querySnapshot.documents.compactMap({ querySnapshot in
                    try? querySnapshot.data(as: ToDo.self)
                })
                
                // Display todos of the picked date
                let todosOnDate = todos.compactMap { todo -> ToDo? in
                    if todo.dueTime.hasSame(.day, as: date) {
                        return todo
                    } else {
                        return nil
                    }
                }
                
                let sepcificDateToDos = todosOnDate.sorted { $0.dueTime < $1.dueTime }
                completion(.success(sepcificDateToDos))
                
            } else if let error = error {
                completion(.failure(error))
            }
        }
        
        return listener
    }
    
    // for push notification
    func todoListener(completion: @escaping (Result<ListenerType<[ToDo]>, Error>) -> Void) {
        
        guard let currentUser = MemberManager.shared.current else { return }
        
        dataBase.whereField("executorId", isEqualTo: currentUser.id).addSnapshotListener { (querySnapshot, error) in
            
            if let querySnapshot = querySnapshot {
                
                let todos = querySnapshot.documents.compactMap({ querySnapshot in
                    try? querySnapshot.data(as: ToDo.self)
                })
                
                querySnapshot.documentChanges.forEach { diff in
                    switch diff.type {
                    case .added:
                        completion(.success(.added(data: todos)))
                        
                    case .modified:
                        completion(.success(.modified(data: todos)))
                        
                    case .removed:
                        completion(.success(.removed(data: todos)))
                    }
                }
                
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}
