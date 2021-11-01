//
//  ProfileViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/20.
// swiftlint:disable function_body_length

import UIKit
import IQKeyboardManagerSwift

class ProfileViewController: UIViewController {
    
    private var navigationBackgroundView: NavigationBackgroundView!
    private var nameTitleLabel: MediumLabel!
    private var iconImageView: UIImageView!
    private var editNameButton: IconButton!
    private var textField: NoBorderTextField!
    private var memberName: String? {
        didSet {
            if memberName != nil && memberName == "" {
                textField.isEnabled = false
            }
        }
    }
    private var furkidsTitleLabel: MediumLabel!
    private var addPetButton: IconButton!
    private var petTableView: UITableView!
    
    private var currentUser: Member! = MemberModel.shared.current // 只有一開始跟membermodel.current一樣，後續需要再持續更新
    private var pets = [Pet]()

    override func viewWillAppear(_ animated: Bool) {
        // MARK: Navigation controller
        self.navigationItem.title = "Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: 24) as Any, NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Img.iconsQrcode.obj, style: .plain, target: self, action: #selector(tapQrcode))
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBackgroundView = NavigationBackgroundView()
        view.addSubview(navigationBackgroundView)
        NSLayoutConstraint.activate([
            navigationBackgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: -20),
            navigationBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBackgroundView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        // MARK: UI objects
        nameTitleLabel = MediumLabel(size: 18, text: "Name", textColor: .white)
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
        textField.isEnabled = false
        textField.addTarget(self, action: #selector(nameEndEditing), for: .editingDidEnd)
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2 / 3)
        ])
        
        furkidsTitleLabel = MediumLabel(size: 18, text: "Furkids", textColor: .mainBlue)
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
            addPetButton.widthAnchor.constraint(equalToConstant: 50),
            addPetButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        petTableView = UITableView()
        petTableView.register(PetTableViewCell.self, forCellReuseIdentifier: "PetTableViewCell")
        petTableView.separatorColor = .clear
        petTableView.backgroundColor = .white
        petTableView.estimatedRowHeight = 100
        petTableView.rowHeight = UITableView.automaticDimension
        petTableView.allowsSelection = true
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
        queryData(currentUser: MemberModel.shared.current ?? self.currentUser)
        MemberModel.shared.addUserListener { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(.added(members: let members)):
                self.queryData(currentUser: members.first ?? self.currentUser)
                MemberModel.shared.current = members.first
                
            case .success(.modified(members: let members)):
                self.queryData(currentUser: members.first ?? self.currentUser)
                MemberModel.shared.current = members.first
                
            case .success(.removed(members: let members)):
                self.queryData(currentUser: members.first ?? self.currentUser)
                MemberModel.shared.current = members.first
                
            case .failure(let error):
                print("lisener error at profileVC", error)
            }
        }
    }
    
    // MARK: functions
    func queryData(currentUser: Member) {
        PetModel.shared.queryPets(ids: currentUser.petIds) { [weak self] result in
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
        let getInvitationVC = GetInvitationViewController(currentUser: currentUser)
        present(getInvitationVC, animated: true, completion: nil)
    }
    
    @objc func tapEditName(sender: UIButton) {
        textField.isEnabled = true
        textField.becomeFirstResponder()
    }
    
    @objc private func nameEndEditing(_ textField: UITextField) {
        MemberModel.shared.current?.name = textField.text ?? currentUser.name
        MemberModel.shared.updateCurrentUser()
        textField.isEnabled = !textField.hasText
        view.endEditing(true)
    }
    
    @objc func tapAddPet(sender: UIButton) {
        let addPetViewController = AddPetViewController(currentUser: MemberModel.shared.current ?? currentUser, selectedPet: nil)
        self.navigationController?.pushViewController(addPetViewController, animated: true)
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetTableViewCell", for: indexPath)
        guard let petCell = cell as? PetTableViewCell else { return cell }
        petCell.selectionStyle = .none
        petCell.reload(pet: pets[indexPath.row])
        return petCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPet = pets[indexPath.row]
        let editPetViewController = AddPetViewController(currentUser: MemberModel.shared.current ?? currentUser, selectedPet: selectedPet)
        self.navigationController?.pushViewController(editPetViewController, animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            // get the deleting pet
            let pet = self.pets[indexPath.row]
            
            // update deleted petIds
            MemberModel.shared.current?.petIds.removeAll { $0 == pet.id }
            MemberModel.shared.updateCurrentUser()
            
            // update that pet's memberIds
            pet.memberIds.removeAll { $0 == MemberModel.shared.current?.id }
            PetModel.shared.updatePet(id: pet.id, pet: pet)
            
            completionHandler(true)
        }
        
        deleteAction.image = Img.iconsDelete.obj
        deleteAction.backgroundColor = .white
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

}
