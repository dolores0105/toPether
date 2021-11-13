//
//  ProfileViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/20.
// swiftlint:disable function_body_length

import UIKit
import IQKeyboardManagerSwift

class ProfileViewController: UIViewController {
    
    private var cardView: CardView!
    private var qrcodeTitleLabel: MediumLabel!
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
    
    private var qrCodeButton: IconButton!
    private var furkidsTitleLabel: MediumLabel!
    private var addPetButton: IconButton!
    private var petTableView: UITableView!
    
    private var currentUser: Member! = MemberModel.shared.current // update needed
    private var pets = [Pet]()

    override func viewWillAppear(_ animated: Bool) {

        self.navigationItem.title = "Profile"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .mainBlue
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: 22) as Any, NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        appearance.shadowColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Img.iconsSetting.obj, style: .plain, target: self, action: #selector(tapSetting))
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainBlue
        
        // MARK: UI objects
        guard let currentUser = MemberModel.shared.current else { return }
        qrcodeTitleLabel = MediumLabel(size: 18, text: "\(currentUser.name)'s QR Code", textColor: .white)
        view.addSubview(qrcodeTitleLabel)
        NSLayoutConstraint.activate([
            qrcodeTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            qrcodeTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            qrcodeTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
//        editNameButton = IconButton(self, action: #selector(tapEditName), img: Img.iconsEdit)
//        editNameButton.backgroundColor = .mainBlue
//        view.addSubview(editNameButton)
//        NSLayoutConstraint.activate([
//            editNameButton.centerYAnchor.constraint(equalTo: qrcodeTitleLabel.centerYAnchor),
//            editNameButton.leadingAnchor.constraint(equalTo: qrcodeTitleLabel.trailingAnchor, constant: 20),
//            editNameButton.widthAnchor.constraint(equalToConstant: 60),
//            editNameButton.heightAnchor.constraint(equalToConstant: 60)
//        ])
        
//        textField = NoBorderTextField(name: currentUser.name)
//        textField.font = UIFont.regular(size: 20)
//        textField.isUserInteractionEnabled = true
//        textField.addTarget(self, action: #selector(tapEditName), for: .touchUpInside)
//        textField.isEnabled = false
//        textField.addTarget(self, action: #selector(nameEndEditing), for: .editingDidEnd)
//        view.addSubview(textField)
//        NSLayoutConstraint.activate([
//            textField.topAnchor.constraint(equalTo: qrcodeTitleLabel.bottomAnchor, constant: 8),
//            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
//            textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2 / 3)
//        ])
        
        qrCodeButton = IconButton(self, action: #selector(tapQrcode), img: Img.iconsQrcode)
        qrCodeButton.backgroundColor = .mainBlue
        view.addSubview(qrCodeButton)
        NSLayoutConstraint.activate([
            qrCodeButton.topAnchor.constraint(equalTo: qrcodeTitleLabel.bottomAnchor, constant: 4),
            qrCodeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            qrCodeButton.widthAnchor.constraint(equalToConstant: 60),
            qrCodeButton.heightAnchor.constraint(equalTo: qrCodeButton.widthAnchor)
        ])
        
        cardView = CardView(color: .white, cornerRadius: 20)
        view.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: qrCodeButton.bottomAnchor, constant: 4),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        furkidsTitleLabel = MediumLabel(size: 20, text: "Furkids", textColor: .mainBlue)
        view.addSubview(furkidsTitleLabel)
        NSLayoutConstraint.activate([
            furkidsTitleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 40),
            furkidsTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            furkidsTitleLabel.widthAnchor.constraint(equalToConstant: 78)
        ])
        
        addPetButton = IconButton(self, action: #selector(tapAddPet), img: Img.iconsAdd)
        addPetButton.layer.borderWidth = 0
        view.addSubview(addPetButton)
        NSLayoutConstraint.activate([
            addPetButton.centerYAnchor.constraint(equalTo: furkidsTitleLabel.centerYAnchor),
            addPetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
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
        queryData(currentUser: MemberModel.shared.current ?? self.currentUser)
        MemberModel.shared.addUserListener { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(.added(members: let members)):
                guard let currentUser = members.first else { return }
                self.queryData(currentUser: currentUser)
                self.qrcodeTitleLabel.text = "\(currentUser.name)'s QR Code"

            case .success(.modified(members: let members)):
                guard let currentUser = members.first else { return }
                self.queryData(currentUser: currentUser)
                self.qrcodeTitleLabel.text = "\(currentUser.name)'s QR Code"

            case .success(.removed(members: let members)):
                guard let currentUser = members.first else { return }
                self.queryData(currentUser: currentUser)

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
//                print("fetch pets at profile:", self.pets)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func tapQrcode(sender: IconButton) {
        let getInvitationVC = GetInvitationViewController(currentUser: currentUser, isFirstSignIn: false)
        present(getInvitationVC, animated: true, completion: nil)
    }
    
    @objc private func tapSetting(sender: UITabBarItem) {
        let settingViewController = SettingViewController()
        navigationController?.pushViewController(settingViewController, animated: true)
    }

    @objc func tapAddPet(sender: UIButton) {
        let addPetViewController = AddPetViewController(currentUser: MemberModel.shared.current ?? currentUser, selectedPet: nil, isFirstSignIn: false)
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
        let editPetViewController = AddPetViewController(currentUser: MemberModel.shared.current ?? currentUser, selectedPet: selectedPet, isFirstSignIn: false)
        self.navigationController?.pushViewController(editPetViewController, animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            let deleteAlert = Alert.deleteAlert(title: "Delete furkid",
                                                message: "You'd need to be invited again, or you could not view previous info of this pet")
            {
                // get the deleting pet
                let pet = self.pets[indexPath.row]
                
                // update deleted petIds
                MemberModel.shared.current?.petIds.removeAll { $0 == pet.id }
                MemberModel.shared.updateCurrentUser()
                
                // update that pet's memberIds
                pet.memberIds.removeAll { $0 == MemberModel.shared.current?.id }
                PetModel.shared.updatePet(id: pet.id, pet: pet)
                
            }
            
            self.present(deleteAlert, animated: true)
            
            completionHandler(true)
        }
        
        deleteAction.image = Img.iconsDelete.obj
        deleteAction.backgroundColor = .white
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

}
