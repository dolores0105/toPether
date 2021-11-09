//
//  ToDoRecordViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/9.
//

import UIKit

class ToDoRecordViewController: UIViewController, UIScrollViewDelegate {
    
    convenience init(todo: ToDo?, petName: String?, executorName: String?) {
        self.init()
        self.todo = todo
        self.petName = petName
        self.executorName = executorName
    }
    private var todo: ToDo?
    private var petName: String?
    private var executorName: String?
    
    private var scrollView: UIScrollView!
    private var petsLabel: MediumLabel!
    private var petTextField: BlueBorderTextField!
    private var petPickerView: UIPickerView!
    private var contentLabel: MediumLabel!
    private var contentTextField: BlueBorderTextField!
    private var timeLabel: MediumLabel!
    private let timeDatePicker = UIDatePicker()
    private var executorsLabel: MediumLabel!
    private var executorTextField: BlueBorderTextField!
    private var executorPickerView: UIPickerView!
    private var okButton: RoundButton!
    
    private var pets = [Pet]()
    private var petNamesCache = [String: String]()
    private var memberNamesCache = [String: String]()
    
    override func viewWillAppear(_ animated: Bool) {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: 24) as Any, NSAttributedString.Key.foregroundColor: UIColor.mainBlue]
        navigationController?.navigationBar.tintColor = .mainBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationItem.title = "Todo"
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        configScrollView()
        configPetsLabel()
        configPetPickerView()
        configContentLabel()
        configContentTextField()
        configTimeLabel()
        configTimeDatePicker()
        configExecutorsLabel()
        configExecutorPickerView()
        configOkButton()
        
        // MARK: Data
        guard let currentUser = MemberModel.shared.current else { return }
        PetModel.shared.queryPets(ids: currentUser.petIds) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let pets):
                self.pets = pets
                
                for pet in pets where self.petNamesCache[pet.id] == nil {
                    self.petNamesCache[pet.id] = pet.name
                }
                
                if let petName = self.petName, let petId = self.petNamesCache.someKey(forValue: petName) {
                    
                    PetModel.shared.queryPet(id: petId) { pet in
                        guard let pet = pet else {
                            return
                        }
                        self.queryMemberNames(pet: pet)
                    }
                }
                
            case .failure(let error):
                print("Query currentUser's pets error", error)
            }
        }
    
        renderExistingData(todo: self.todo, petName: self.petName, executorName: self.executorName)
    }
    
    @objc private func tapOK(sender: RoundButton) {
        guard let todo = todo else {
            
            guard let petName = petTextField.text,
            let todoContent = contentTextField.text,
            let executorName = executorTextField.text, let currentUser = MemberModel.shared.current else { return }
            
            guard let petId = petNamesCache.someKey(forValue: petName), let executorId = memberNamesCache.someKey(forValue: executorName) else { return }
            
            ToDoManager.shared.setToDo(creatorId: currentUser.id, executorId: executorId, petId: petId, dueTime: timeDatePicker.date, content: todoContent) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let todo):
                    print("Create todo", todo.content)
                    self.navigationController?.popViewController(animated: true)
                    
                case .failure(let error):
                    print("Create todo error", error)
                }
            }
            return
        }
    
        ToDoManager.shared.updateToDo(todo: todo) { todo in
            guard todo != nil else {
                print("Update todo failed")
                return
            }
            navigationController?.popViewController(animated: true)
        }

    }
    
    private func renderExistingData(todo: ToDo?, petName: String?, executorName: String?) {
        
        guard let todo = todo, let petName = petName, let executorName = executorName else { return }
        
        petTextField.text = petName
        contentTextField.text = todo.content
        timeDatePicker.date = todo.dueTime
        executorTextField.text = executorName
    }
    
    private func queryMemberNames(pet: Pet) {
        MemberModel.shared.queryMembers(ids: pet.memberIds) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let members):
                self.memberNamesCache = [:]
                for member in members where self.memberNamesCache[member.id] == nil {
                    self.memberNamesCache[member.id] = member.name
                }
            case .failure(let error):
                print("query members' names error", error)
            }
        }
    }
}

extension ToDoRecordViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case petPickerView:
            let petNames = Array(petNamesCache.values)
            return petNames[row]
            
        case executorPickerView:
            let memberNames = Array(memberNamesCache.values)
            return memberNames[row]
            
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case petPickerView:
            
            let selectedPetName = Array(petNamesCache.values)[row]
            petTextField.text = selectedPetName
            
            let selectedPetId = Array(petNamesCache.keys)[row]
            PetModel.shared.queryPet(id: selectedPetId) { pet in
                guard let pet = pet else {
                    return // didn't find pet
                }
                
                self.queryMemberNames(pet: pet)
//                MemberModel.shared.queryMembers(ids: pet.memberIds) { [weak self] result in
//                    guard let self = self else { return }
//                    switch result {
//                    case .success(let members):
//                        self.memberNamesCache = [:]
//                        for member in members where self.memberNamesCache[member.id] == nil {
//                            self.memberNamesCache[member.id] = member.name
//                        }
//                    case .failure(let error):
//                        print("query members' names error", error)
//                    }
//                }
            }
            
        case executorPickerView:
            executorTextField.text = Array(memberNamesCache.values)[row]
            
        default:
            executorTextField.text = Array(memberNamesCache.values)[row]
        }
    }
}

extension ToDoRecordViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView {
        case petPickerView:
            return 1
        case executorPickerView:
            return 1
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case petPickerView:
            return petNamesCache.count
        case executorPickerView:
            return memberNamesCache.count
        default:
            return 1
        }
    }
}

extension ToDoRecordViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if petTextField.hasText && contentTextField.hasText && executorTextField.hasText {
            
            guard let petName = petTextField.text,
            let todoContent = contentTextField.text,
            let executorName = executorTextField.text else { return }
            
            guard let petId = petNamesCache.someKey(forValue: petName), let executorId = memberNamesCache.someKey(forValue: executorName) else { return }
            
            todo?.petId = petId
            todo?.content = todoContent
            todo?.dueTime = timeDatePicker.date
            todo?.executorId = executorId
            
            okButton.isEnabled = true
            okButton.backgroundColor = .mainYellow
            
        } else {
            okButton.isEnabled = false
            okButton.backgroundColor = .lightBlueGrey
        }
    }
}

extension ToDoRecordViewController {
    private func configScrollView() {
        scrollView = UIScrollView()
        let fullsize = UIScreen.main.bounds.size
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: fullsize.width, height: 650)
        scrollView.isScrollEnabled = true
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configPetsLabel() {
        petsLabel = MediumLabel(size: 16, text: "Furkids", textColor: .mainBlue)
        scrollView.addSubview(petsLabel)
        NSLayoutConstraint.activate([
            petsLabel.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            petsLabel.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 32),
            petsLabel.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -32)
        ])
    }
    
    private func configPetPickerView() {
        petTextField = BlueBorderTextField(text: nil)
        petPickerView = UIPickerView()
        petPickerView.delegate = self
        petPickerView.dataSource = self
        petTextField.inputView = petPickerView
        petTextField.delegate = self
        scrollView.addSubview(petTextField)
        NSLayoutConstraint.activate([
            petTextField.topAnchor.constraint(equalTo: petsLabel.bottomAnchor, constant: 8),
            petTextField.leadingAnchor.constraint(equalTo: petsLabel.leadingAnchor),
            petTextField.trailingAnchor.constraint(equalTo: petsLabel.trailingAnchor)
        ])
    }
    
    private func configContentLabel() {
        contentLabel = MediumLabel(size: 16, text: "Todo list", textColor: .mainBlue)
        scrollView.addSubview(contentLabel)
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: petTextField.bottomAnchor, constant: 24),
            contentLabel.leadingAnchor.constraint(equalTo: petsLabel.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: petsLabel.trailingAnchor)
        ])
    }
    
    private func configContentTextField() {
        contentTextField = BlueBorderTextField(text: nil)
        contentTextField.delegate = self
        scrollView.addSubview(contentTextField)
        NSLayoutConstraint.activate([
            contentTextField.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            contentTextField.leadingAnchor.constraint(equalTo: petsLabel.leadingAnchor),
            contentTextField.trailingAnchor.constraint(equalTo: petsLabel.trailingAnchor)
        ])
    }
    
    private func configTimeLabel() {
        timeLabel = MediumLabel(size: 16, text: "Time", textColor: .mainBlue)
        scrollView.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: contentTextField.bottomAnchor, constant: 24),
            timeLabel.leadingAnchor.constraint(equalTo: petsLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: petsLabel.trailingAnchor)
        ])
    }
    
    private func configTimeDatePicker() {
        timeDatePicker.datePickerMode = .dateAndTime
        timeDatePicker.preferredDatePickerStyle = .compact
        timeDatePicker.backgroundColor = .white
        timeDatePicker.translatesAutoresizingMaskIntoConstraints = false
        timeDatePicker.tintColor = .mainBlue
        scrollView.addSubview(timeDatePicker)
        NSLayoutConstraint.activate([
            timeDatePicker.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
            timeDatePicker.leadingAnchor.constraint(equalTo: petsLabel.leadingAnchor),
            timeDatePicker.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func configExecutorsLabel() {
        executorsLabel = MediumLabel(size: 16, text: "Who", textColor: .mainBlue)
        scrollView.addSubview(executorsLabel)
        NSLayoutConstraint.activate([
            executorsLabel.topAnchor.constraint(equalTo: timeDatePicker.bottomAnchor, constant: 24),
            executorsLabel.leadingAnchor.constraint(equalTo: petsLabel.leadingAnchor),
            executorsLabel.trailingAnchor.constraint(equalTo: petsLabel.trailingAnchor)
        ])
    }
    
    private func configExecutorPickerView() {
        executorTextField = BlueBorderTextField(text: nil)
        executorPickerView = UIPickerView()
        executorPickerView.delegate = self
        executorPickerView.dataSource = self
        executorTextField.inputView = executorPickerView
        executorTextField.delegate = self
        scrollView.addSubview(executorTextField)
        NSLayoutConstraint.activate([
            executorTextField.topAnchor.constraint(equalTo: executorsLabel.bottomAnchor, constant: 8),
            executorTextField.leadingAnchor.constraint(equalTo: petsLabel.leadingAnchor),
            executorTextField.trailingAnchor.constraint(equalTo: petsLabel.trailingAnchor)
        ])
    }
    
    private func configOkButton() {
        okButton = RoundButton(text: "OK", size: 18)
        if todo != nil {
            okButton.isEnabled = true
            okButton.backgroundColor = .mainYellow
        } else {
            okButton.isEnabled = false
            okButton.backgroundColor = .lightBlueGrey
        }
        
        okButton.addTarget(self, action: #selector(tapOK), for: .touchUpInside)
        scrollView.addSubview(okButton)
        NSLayoutConstraint.activate([
            okButton.leadingAnchor.constraint(equalTo: petsLabel.leadingAnchor),
            okButton.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -64),
            okButton.topAnchor.constraint(equalTo: executorTextField.bottomAnchor, constant: 40)
        ])
    }
}
