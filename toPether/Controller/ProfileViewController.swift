//
//  ProfileViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/20.
//

import UIKit
import IQKeyboardManagerSwift

class ProfileViewController: UIViewController {
    
    var navigationBackgroundView: NavigationBackgroundView!
    var nameTitleLabel: MediumLabel!
    var iconImageView: UIImageView!
    var editNameButton: IconButton!
    var textField: NoBorderTextField!
    var memberName: String? {
        didSet {
            if memberName != nil && memberName == "" {
                textField.isEnabled = false
            }
        }
    }
    var furkidsTitleLabel: MediumLabel!
    var addPetButton: IconButton!
    var petTableView: UITableView!
    
    let userInfo = UserInfo()
    var currentUser = [Member]() // should be only one element
    let petModel = PetModel()
    var pets = [Pet]()
    let memberModel = MemberModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Navigation controller
        self.navigationItem.title = "Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: 24) as Any, NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Img.iconsQrcode.obj, style: .plain, target: self, action: #selector(tapQrcode))
        
        navigationBackgroundView = NavigationBackgroundView()
        view.addSubview(navigationBackgroundView)
        NSLayoutConstraint.activate([
            navigationBackgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: -20),
            navigationBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBackgroundView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // MARK: UI objects
        nameTitleLabel = MediumLabel(size: 18)
        nameTitleLabel.text = "Name"
        nameTitleLabel.textColor = .white
        view.addSubview(nameTitleLabel)
        NSLayoutConstraint.activate([
            nameTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            nameTitleLabel.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        editNameButton = IconButton(self, action: #selector(tapEditName), img: Img.iconsEdit)
        editNameButton.backgroundColor = .mainBlue
        view.addSubview(editNameButton)
        NSLayoutConstraint.activate([
            editNameButton.centerYAnchor.constraint(equalTo: nameTitleLabel.centerYAnchor),
            editNameButton.leadingAnchor.constraint(equalTo: nameTitleLabel.trailingAnchor, constant: 20),
            editNameButton.widthAnchor.constraint(equalToConstant: 60),
            editNameButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        textField = NoBorderTextField(name: memberName)
        textField.delegate = self
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2 / 3)
        ])
        
        furkidsTitleLabel = MediumLabel(size: 18)
        furkidsTitleLabel.text = "Furkids"
        furkidsTitleLabel.textColor = .mainBlue
        view.addSubview(furkidsTitleLabel)
        NSLayoutConstraint.activate([
            furkidsTitleLabel.topAnchor.constraint(equalTo: navigationBackgroundView.bottomAnchor, constant: 40),
            furkidsTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            furkidsTitleLabel.widthAnchor.constraint(equalToConstant: 66)
        ])
        
        addPetButton = IconButton(self, action: #selector(tapAddPet), img: Img.iconsAdd)
        addPetButton.layer.borderWidth = 0
        view.addSubview(addPetButton)
        NSLayoutConstraint.activate([
            addPetButton.centerYAnchor.constraint(equalTo: furkidsTitleLabel.centerYAnchor),
            addPetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            addPetButton.widthAnchor.constraint(equalToConstant: 66),
            addPetButton.heightAnchor.constraint(equalToConstant: 66)
        ])
        
        petTableView = UITableView()
        petTableView.register(PetTableViewCell.self, forCellReuseIdentifier: "PetTableViewCell")
        petTableView.separatorColor = .clear
        petTableView.estimatedRowHeight = 100
        petTableView.rowHeight = UITableView.automaticDimension
        petTableView.allowsSelection = false
        petTableView.delegate = self
        petTableView.dataSource = self
        petTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(petTableView)
        NSLayoutConstraint.activate([
            petTableView.topAnchor.constraint(equalTo: furkidsTitleLabel.bottomAnchor, constant: 30),
            petTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            petTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            petTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
        
        // MARK: Query data
        userInfo.userId = "xzhcxjKGZGKuX3zGgMid" // mock
        queryData()
    }
    
    // MARK: functions
    func queryData() {
        let semaphore = DispatchSemaphore(value: 1)
        DispatchQueue.global().async { [weak self] in
            guard let self = self, let userId = self.userInfo.userId else { return }
            semaphore.wait()
            print("----query current user start----")
            self.memberModel.queryCurrentUser(id: userId) { [weak self] result in
                switch result {
                case .success(let user):
                    guard let self = self else { return }
                    self.currentUser = user
                    self.textField.text = self.currentUser.first?.memberName
                    print("current user info at profile", self.currentUser)
                    semaphore.signal()
                case .failure(let error):
                    print(error)
                }
            }
            
            semaphore.wait()
            guard let petIds = self.currentUser.first?.pets else { return }
            print("----query current user start----")
            self.petModel.queryPets(ids: petIds) { [weak self] result in
                switch result {
                case .success(let pets):
                    guard let self = self else { return }
                    self.pets = pets
                    self.petTableView.reloadData()
                    print("fetch pets at profile:", self.pets)
                    semaphore.signal()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    @objc func tapQrcode(sender: UIBarButtonItem) {
        
    }
    
    @objc func tapEditName(sender: UIButton) {
        textField.isEnabled = true
        textField.becomeFirstResponder()
    }
    
    @objc func tapAddPet(sender: UIButton) {
        
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        memberName = textField.text
        //then update to firebase
        
        self.view.endEditing(true)
        
        if textField.hasText {
            textField.isEnabled = false
        } else {
            textField.isEnabled = true
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetTableViewCell", for: indexPath)
        guard let cell = cell as? PetTableViewCell else { return cell }
        
        cell.reload(pet: pets[indexPath.row])
        return cell
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            print("Delete number", indexPath.row, "pet")
            self.pets.remove(at: indexPath.row)
            self.petTableView.deleteRows(at: [indexPath], with: .left)
            // notify delete to firebase
            
            completionHandler(true)
        }
        
        deleteAction.image = Img.iconsDelete.obj
        deleteAction.backgroundColor = .white
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

}
