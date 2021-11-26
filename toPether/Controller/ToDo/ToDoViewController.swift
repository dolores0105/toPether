//
//  ToDoViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/30.
//

import UIKit
import Lottie
import Firebase

class ToDoViewController: UIViewController {

    private var cardView: CardView!
    private var calendar: UIDatePicker!
    private var toDoTableView: UITableView!
    private var animationView: AnimationView!
    private var listener: ListenerRegistration?
    
    private var toDos = [ToDo]()
    private var executorNameCache = [String: String]() {
        didSet {
            toDoTableView.reloadData()
        }
    }
    private var petNameCache = [String: String]() {
        didSet {
            toDoTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.navigationItem.title = "Todos"
        self.setNavigationBarColor(bgColor: .mainBlue, textColor: .white, tintColor: .white)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Img.iconsAddWhite.obj, style: .plain, target: self, action: #selector(tapAdd))
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainBlue
        configCardView()
        configCalendar()
        configToDoTableView()
        
        // MARK: Data
        addToDoListenerOnDate(date: Date())
        
        addToDoListenerNotification()
    }
    
    private func addToDoListenerOnDate(date: Date) {
        guard let currentUser = MemberManager.shared.current else { return }
        listener = ToDoManager.shared.addToDosListenerOnDate(petIds: currentUser.petIds, date: date) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let todos):
                self.toDos = todos
                
                for todo in todos where self.executorNameCache[todo.executorId] == nil || self.petNameCache[todo.petId] == nil {
                    
                    MemberManager.shared.queryMember(id: todo.executorId) { member in
                        guard let member = member else {
                            self.executorNameCache[todo.executorId] = "anonymous"
                            return
                        }
                        self.executorNameCache[todo.executorId] = member.name
                    }
                    
                    PetManager.shared.queryPet(id: todo.petId) { result in
                        
                        switch result {
                        case .success(let pet):
                            
                            self.petNameCache[todo.petId] = pet.name
                            
                        case .failure(let error):
                            self.presentErrorAlert(message: error.localizedDescription + " Please try again")
                        }
                    }
                }
                
                self.toDoTableView.reloadData()
                
            case .failure(let error):
                print("listen todo error", error)
                self.presentErrorAlert(message: error.localizedDescription + " Please try again")
            }
        }
    }
    
    @objc private func tapAdd(_ sender: UIBarButtonItem) {
        let toDoRecordViewController = ToDoRecordViewController(todo: nil, petName: nil, executorName: nil)
        navigationController?.pushViewController(toDoRecordViewController, animated: true)
    }
    
    @objc func tapDate(sender: UIDatePicker) {
        let date = sender.date
        
        listener?.remove()
        
        addToDoListenerOnDate(date: date)
    }
    
    private func addToDoListenerNotification() {
        ToDoManager.shared.todoListener { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(.added(data: let todos)):
                
                var badgeStepper: Int = 0
                
                for todo in todos {
                    
                    if todo.dueTime.hasSame(.day, as: Date()) {
                        badgeStepper += 1
                    }
                    
                    self.createNotification(todo: todo, badgeStepper: badgeStepper as NSNumber)
                }
                
            case .success(.modified(data: let todos)):
                
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: todos.compactMap{ $0.id })
                
                var badgeStepper: Int = 0
                
                for todo in todos {
                    
                    if todo.dueTime.hasSame(.day, as: Date()) {
                        badgeStepper += 1
                    }
                    
                    self.createNotification(todo: todo, badgeStepper: badgeStepper as NSNumber)
                }
                
            case .success(.removed(data: let todos)):
            
                var badgeStepper: Int = 0
                
                for todo in todos {
                    
                    if todo.dueTime.hasSame(.day, as: Date()) {
                        badgeStepper += 1
                    }
                }
                
            case .failure(let error):
                print("add todoListeners for notifications error", error)
                self.presentErrorAlert(message: error.localizedDescription + " Please try again")
            }
        }
    }
    
    private func createNotification(todo: ToDo, badgeStepper: NSNumber?) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d HH:mm"
        dateFormatter.timeZone = TimeZone.current
        
        let content = UNMutableNotificationContent()
        content.title = "Todo list"
        content.subtitle = dateFormatter.string(from: todo.dueTime)
        content.body = todo.content
        content.badge = badgeStepper
        content.sound = .default
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: todo.dueTime)
        let month = calendar.component(.month, from: todo.dueTime)
        let day = calendar.component(.day, from: todo.dueTime)
        
        var dateComponents = DateComponents()
        dateComponents.timeZone = .current
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = 7
//        dateComponents.minute = 39
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: todo.id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if error != nil {
                print("add notification failed")
                self.presentErrorAlert(message: error?.localizedDescription ?? "" + " Please try again")
            }
        }
    }
}

extension ToDoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.identifier, for: indexPath)
        guard let toDoCell = cell as? ToDoTableViewCell else { return cell }
        
        let todo = toDos[indexPath.row]
        let executorName = executorNameCache[todo.executorId]
        let petName = petNameCache[todo.petId]
        
        toDoCell.reload(todo: todo, executorName: executorName, petName: petName)
        
        toDoCell.delegate = self
        
        return toDoCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = toDos[indexPath.row]
        let petName = petNameCache[todo.petId]
        let executorName = executorNameCache[todo.executorId]
        
        if !todo.doneStatus {
            let todoRecordViewController = ToDoRecordViewController(todo: todo, petName: petName, executorName: executorName)
            navigationController?.pushViewController(todoRecordViewController, animated: true)
        }
    }
}

extension ToDoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            self.presentDeleteAlert(title: "Delete todo", message: "Do you want to delete this todo?") {
                
                let deleteId = self.toDos[indexPath.row].id
                let deleteContent = self.toDos[indexPath.row].content
                
                ToDoManager.shared.deleteToDo(id: deleteId) { deleteDone in
                    if deleteDone {
                        
                        print("deleted \(deleteId), \(deleteContent)")
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [deleteId])
                    } else {
                        
                        self.presentErrorAlert(message: "Please try again")
                    }
                }
                
            }
                        
            completionHandler(true)
        }
        
        deleteAction.image = Img.iconsDelete.obj
        deleteAction.backgroundColor = .white
        
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
}

extension ToDoViewController: ToDoTableViewCellDelegate {
    func didChangeDoneStatusOnCell(_ cell: ToDoTableViewCell) {
       
        guard let indexPath = toDoTableView.indexPath(for: cell) else { return }
        
        toDos[indexPath.row].doneStatus.toggle()

        ToDoManager.shared.updateToDo(todo: toDos[indexPath.row]) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let todo):
                if todo.doneStatus {
                    self.configAnimation()
                }
                print("updated todo: \(todo.id)")
                
            case .failure(let error):
                self.presentErrorAlert(message: error.localizedDescription)
            }
            self.toDoTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
}

extension ToDoViewController {
    
    private func configCardView() {
        cardView = CardView(color: .white, cornerRadius: 20)
        view.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configCalendar() {
        calendar = UIDatePicker()
        calendar.datePickerMode = .date
        calendar.preferredDatePickerStyle = .inline
        calendar.tintColor = .mainYellow
        calendar.backgroundColor = .white
        calendar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendar)
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            calendar.heightAnchor.constraint(equalTo: calendar.widthAnchor)
        ])
        
        calendar.addTarget(self, action: #selector(tapDate), for: .valueChanged)
    }
    
    private func configToDoTableView() {
        toDoTableView = UITableView()
        toDoTableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: "ToDoTableViewCell")
        toDoTableView.separatorColor = .clear
        toDoTableView.backgroundColor = .white
        toDoTableView.estimatedRowHeight = 150
        toDoTableView.rowHeight = UITableView.automaticDimension
        toDoTableView.allowsSelection = true
        toDoTableView.delegate = self
        toDoTableView.dataSource = self
        toDoTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toDoTableView)
        NSLayoutConstraint.activate([
            toDoTableView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 4),
            toDoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toDoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toDoTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configAnimation() {
        animationView = .init(name: "lottieCongratulation")
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor)
        ])
        
        animationView.loopMode = .playOnce
        animationView.play { [weak self] _ in
            guard let self = self else { return }
            self.animationView.isHidden = true
        }
    }
}
