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
    
    var currentUser: Member! = MemberModel.shared.current
    let petModel = PetModel()
    var pets = [Pet]()

    
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
        
        textField = NoBorderTextField(name: currentUser.name)
        textField.addTarget(self, action: #selector(nameEndEditing), for: .editingDidEnd)
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
        textField.text = currentUser.name
        queryData()
    }
    
    // MARK: functions
    func queryData() {
        petModel.queryPets(ids: currentUser.petIds) { [weak self] result in
            switch result {
            case .success(let pets):
                guard let self = self else { return }
                self.pets = pets
                self.petTableView.reloadData()
                print("fetch pets at profile:", self.pets)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func tapQrcode(sender: UIBarButtonItem) {
        
    }
    
    @objc func tapEditName(sender: UIButton) {
        textField.isEnabled = true
        textField.becomeFirstResponder()
    }
    
    @objc private func nameEndEditing(_ textField: UITextField) {
        print(textField.text)
        currentUser.name = textField.text ?? currentUser.name
        MemberModel.shared.updateCurrentUser()
        textField.isEnabled = !textField.hasText
        view.endEditing(true)
    }
    
    @objc func tapAddPet(sender: UIButton) {
        
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
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
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }

            self.currentUser.petIds.remove(at: indexPath.row)
            self.pets.remove(at: indexPath.row)
            print("self.pets", self.pets)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
            
            MemberModel.shared.updateCurrentUser()
            
            completionHandler(true)
        }
        
        deleteAction.image = Img.iconsDelete.obj
        deleteAction.backgroundColor = .white
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

}
