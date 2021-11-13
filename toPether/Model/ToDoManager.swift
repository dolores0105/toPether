//
//  ToDoManager.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/8.
//

import Firebase
import Foundation

enum TodoListenerType {
    case added(todos: [ToDo])
    case modified(todos: [ToDo])
    case removed(todos: [ToDo])
}

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
    
    func queryToDosOnDate(petIds: [String], date: Date, completion: @escaping (Result<[ToDo], Error>) -> Void) {
        
        guard !petIds.isEmpty else { // if petIds is an empty array
            completion(Result.failure(CommonError.emptyArrayInFilter))
            return
        }
        
        dataBase.collection("todos").whereField("petId", in: petIds).getDocuments { (querySnapshot, error) in
            
            if let querySnapshot = querySnapshot {
                let todos = querySnapshot.documents.compactMap({ querySnapshot in
                    try? querySnapshot.data(as: ToDo.self)
                })
                
                let todosOnDate = todos.compactMap { todo -> ToDo? in
                    if todo.dueTime.hasSame(.day, as: date) {
                        return todo
                    } else {
                        return nil
                    }
                }
                
                let sepcificDateToDos = todosOnDate.sorted { $0.dueTime > $1.dueTime }
                completion(.success(sepcificDateToDos))
                
            } else if let error = error {
                completion(.failure(error))
            }
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
    
    func addToDosListenerOnDate(petIds: [String], date: Date, completion: @escaping (Result<[ToDo], Error>) -> Void) -> ListenerRegistration? {
        
        guard !petIds.isEmpty else { // if petIds is an empty array
            completion(Result.failure(CommonError.emptyArrayInFilter))
            return nil
        }
        
        let listener = dataBase.collection("todos").whereField("petId", in: petIds).addSnapshotListener { (querySnapshot, error) in
            
            if let querySnapshot = querySnapshot {
                let todos = querySnapshot.documents.compactMap({ querySnapshot in
                    try? querySnapshot.data(as: ToDo.self)
                })
                
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
    
    func updateToDo(todo: ToDo, completion: (ToDo?) -> Void) {
        do {
            try dataBase.collection("todos").document(todo.id).setData(from: todo)
            completion(todo)
        } catch {
            print("update todo error", error)
            completion(nil)
        }
    }
    
    func deleteToDo(id: String, completion: @escaping(Bool) -> Void) {
        dataBase.collection("todos").document(id).delete() { error in
            if let error = error {
                print("delete todo error", error)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func todoListener(completion: @escaping (Result<TodoListenerType, Error>) -> Void) {
        
        guard let currentUser = MemberModel.shared.current else { return }
        
        dataBase.collection("todos").whereField("executorId", isEqualTo: currentUser.id).addSnapshotListener { (querySnapshot, error) in
            
            if let querySnapshot = querySnapshot {
                
                let todos = querySnapshot.documents.compactMap({ querySnapshot in
                    try? querySnapshot.data(as: ToDo.self)
                })
                
                querySnapshot.documentChanges.forEach { diff in
                    switch diff.type {
                    case .added:
                        print("added todos")
                        completion(.success(.added(todos: todos)))
                        
                    case .modified:
                        print("modified todo")
                        completion(.success(.modified(todos: todos)))
                        
                    case .removed:
                        print("removed todo")
                        completion(.success(.removed(todos: todos)))
                    }
                }
                
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}
