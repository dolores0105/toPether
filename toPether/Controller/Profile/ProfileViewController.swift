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
    private var greetingLabel: RegularLabel!
    private var nameTextField: NoBorderTextField!
    private var furkidsTitleLabel: MediumLabel!
    private var addPetButton: IconButton!
    private var petTableView: UITableView!
    private var firstImageView = UIImageView(image: Img.iconsPang.obj)
    private var guideCreateLabel = RegularLabel(size: 16, text: "Tap Plus button to create a pet group", textColor: .deepBlueGrey)
    private var secondImageView = UIImageView(image: Img.iconsPang.obj)
    private var guideGetInvitationLabel = RegularLabel(size: 16, text: "Tap QR Code button to be invited", textColor: .deepBlueGrey)
    
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Img.iconsQrcode.obj, style: .plain, target: self, action: #selector(tapQrcode))
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainBlue
        
        // MARK: UI objects
        configGreetingLabel()
        configNameTextField()
        configCardView()
        configFurKidLabel()
        configAddPetButton()
        configPetTableView()
        
        // MARK: Query data
        queryData(currentUser: MemberModel.shared.current ?? self.currentUser)
        MemberModel.shared.addUserListener { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(.added(members: let members)):
                guard let currentUser = members.first else { return }
                self.queryData(currentUser: currentUser)
                self.nameTextField.text = currentUser.name

            case .success(.modified(members: let members)):
                guard let currentUser = members.first else { return }
                self.queryData(currentUser: currentUser)
                self.nameTextField.text = currentUser.name

            case .success(.removed(members: let members)):
                guard let currentUser = members.first else { return }
                self.queryData(currentUser: currentUser)

            case .failure(let error):
                print("lisener error at profileVC", error)
                self.presentErrorAlert(title: "Something went wrong", message: error.localizedDescription + " Please try again")
            }
        }
    }
    
    // MARK: functions
    func queryData(currentUser: Member) {
        PetManager.shared.queryPets(ids: currentUser.petIds) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let pets):
                self.pets = pets
                self.petTableView.reloadData()

                self.firstImageView.removeFromSuperview()
                self.guideCreateLabel.removeFromSuperview()
                self.secondImageView.removeFromSuperview()
                self.guideGetInvitationLabel.removeFromSuperview()
                
            case .failure(let error):
                print(error)
                self.configFirstImageView()
                self.configGuideCreateLabel()
                self.configSecondImageView()
                self.configGuideInvitationLabel()
            }
        }
    }
    
    @objc func tapQrcode(sender: IconButton) {
        let getInvitationVC = GetInvitationViewController(currentUser: currentUser, isFirstSignIn: false)
        present(getInvitationVC, animated: true, completion: nil)
    }
    
    @objc private func tapNameTextField(_ sender: SettingButton) {
        nameTextField.becomeFirstResponder()
    }
    
    @objc private func nameEndEditing(_ textField: UITextField) {
        guard let currentUser = MemberModel.shared.current else { return }
        MemberModel.shared.current?.name = nameTextField.text ?? currentUser.name
        MemberModel.shared.updateCurrentUser()
        view.endEditing(true)
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
            { // action after user tapped delete
                // get the deleting pet
                let pet = self.pets[indexPath.row]
                
                // update deleted petIds
                MemberModel.shared.current?.petIds.removeAll { $0 == pet.id }
                MemberModel.shared.updateCurrentUser()
                
                // update that pet's memberIds
                pet.memberIds.removeAll { $0 == MemberModel.shared.current?.id }
                PetManager.shared.updatePetObject(petId: pet.id, objectType: .pet, object: pet) { result in
                    switch result {
                    case .success(let string):
                        print(string)

                    case .failure(let error):
                        self.presentErrorAlert(title: "Something went wrong", message: error.localizedDescription + " Please try again")
                    }
                }
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

extension ProfileViewController {
    
    private func configGreetingLabel() {
        greetingLabel = RegularLabel(size: 18, text: "How's it going?", textColor: .white)
        greetingLabel.textAlignment = .center
        view.addSubview(greetingLabel)
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            greetingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            greetingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configNameTextField() {
        nameTextField = NoBorderTextField(bgColor: .clear, textColor: .white)
        nameTextField.font = UIFont.medium(size: 18)
        nameTextField.textAlignment = .center
        nameTextField.text = currentUser.name
        nameTextField.isUserInteractionEnabled = true
        nameTextField.addTarget(self, action: #selector(tapNameTextField), for: .touchUpInside)
        nameTextField.addTarget(self, action: #selector(nameEndEditing), for: .editingDidEnd)
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 4),
            nameTextField.heightAnchor.constraint(equalToConstant: 32),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 2)
        ])
    }
    
    private func configCardView() {
        cardView = CardView(color: .white, cornerRadius: 20)
        view.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 12),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configFurKidLabel() {
        furkidsTitleLabel = MediumLabel(size: 20, text: "Furkids", textColor: .mainBlue)
        view.addSubview(furkidsTitleLabel)
        NSLayoutConstraint.activate([
            furkidsTitleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 40),
            furkidsTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            furkidsTitleLabel.widthAnchor.constraint(equalToConstant: 78)
        ])
    }
    
    private func configAddPetButton() {
        addPetButton = IconButton(self, action: #selector(tapAddPet), img: Img.iconsAdd)
        addPetButton.layer.borderWidth = 0
        view.addSubview(addPetButton)
        NSLayoutConstraint.activate([
            addPetButton.centerYAnchor.constraint(equalTo: furkidsTitleLabel.centerYAnchor),
            addPetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            addPetButton.widthAnchor.constraint(equalToConstant: 50),
            addPetButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configPetTableView() {
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
    }
    
    private func configFirstImageView() {
        firstImageView.translatesAutoresizingMaskIntoConstraints = false
        firstImageView.alpha = 0.2
        view.addSubview(firstImageView)
        NSLayoutConstraint.activate([
            firstImageView.topAnchor.constraint(equalTo: furkidsTitleLabel.bottomAnchor, constant: 48),
            firstImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            firstImageView.widthAnchor.constraint(equalToConstant: 25),
            firstImageView.heightAnchor.constraint(equalTo: firstImageView.widthAnchor)
        ])
    }
    
    private func configGuideCreateLabel() {
        guideCreateLabel.numberOfLines = 0
        view.addSubview(guideCreateLabel)
        NSLayoutConstraint.activate([
            guideCreateLabel.topAnchor.constraint(equalTo: firstImageView.topAnchor),
            guideCreateLabel.leadingAnchor.constraint(equalTo: firstImageView.trailingAnchor, constant: 20),
            guideCreateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configSecondImageView() {
        secondImageView.translatesAutoresizingMaskIntoConstraints = false
        secondImageView.alpha = 0.2
        view.addSubview(secondImageView)
        NSLayoutConstraint.activate([
            secondImageView.topAnchor.constraint(equalTo: guideCreateLabel.bottomAnchor, constant: 24),
            secondImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            secondImageView.widthAnchor.constraint(equalToConstant: 25),
            secondImageView.heightAnchor.constraint(equalTo: secondImageView.widthAnchor)
        ])
    }

    private func configGuideInvitationLabel() {
        guideGetInvitationLabel.numberOfLines = 0
        view.addSubview(guideGetInvitationLabel)
        NSLayoutConstraint.activate([
            guideGetInvitationLabel.topAnchor.constraint(equalTo: secondImageView.topAnchor),
            guideGetInvitationLabel.leadingAnchor.constraint(equalTo: secondImageView.trailingAnchor, constant: 20),
            guideGetInvitationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
}
