//
//  ProfileViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/20.
// 

import UIKit
import IQKeyboardManagerSwift

class ProfileViewController: UIViewController {
    
    private var currentUser: Member! = MemberManager.shared.current
    private var pets = [Pet]()

    // MARK: - Life Cycles
    
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
        
        queryData(currentUser: MemberManager.shared.current ?? self.currentUser)
        addListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.navigationItem.title = "Profile"
        self.setNavigationBarColor(bgColor: .mainBlue, textColor: .white, tintColor: .white)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Img.iconsSetting.obj, style: .plain, target: self, action: #selector(tapSetting))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Img.iconsQrcode.obj, style: .plain, target: self, action: #selector(tapQrcode))
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Data Functions
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
                self.petTableView.isHidden = false
                
            case .failure(let error):
                print(error)
                self.configFirstImageView()
                self.configGuideCreateLabel()
                self.configSecondImageView()
                self.configGuideInvitationLabel()
                self.petTableView.isHidden = true
            }
        }
    }
    
    private func addListener() {
        MemberManager.shared.addUserListener { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(.added(data: let member)), .success(.modified(data: let member)):
                self.queryData(currentUser: member)
                self.nameTextField.text = member.name

            case .success(.removed(data: let member)):
                self.queryData(currentUser: member)

            case .failure(let error):
                print("lisener error at profileVC", error)
                self.presentErrorAlert(message: error.localizedDescription + " Please try again")
            }
        }
    }
    
    // MARK: - @objc Functions
    
    @objc private func tapQrcode(sender: IconButton) {
        let getInvitationVC = GetInvitationViewController(currentUser: currentUser, isFirstSignIn: false)
        present(getInvitationVC, animated: true, completion: nil)
    }
    
    @objc private func tapNameTextField(_ sender: SettingButton) {
        nameTextField.becomeFirstResponder()
    }
    
    @objc private func nameEndEditing(_ textField: UITextField) {
        guard let currentUser = MemberManager.shared.current else { return }
        MemberManager.shared.current?.name = nameTextField.text ?? currentUser.name
        MemberManager.shared.updateCurrentUser()
        view.endEditing(true)
    }
    
    @objc private func tapSetting(sender: UITabBarItem) {
        let settingViewController = SettingViewController()
        navigationController?.pushViewController(settingViewController, animated: true)
    }

    @objc private func tapAddPet(sender: UIButton) {
        let addPetViewController = AddPetViewController(currentUser: MemberManager.shared.current ?? currentUser, selectedPet: nil, isFirstSignIn: false)
        self.navigationController?.pushViewController(addPetViewController, animated: true)
    }
    
    // MARK: - UI Properties
    
    private lazy var cardView: CardView = {
        let cardView = CardView(color: .white, cornerRadius: 20)
        return cardView
    }()
    
    private lazy var greetingLabel: RegularLabel = {
        let greetingLabel = RegularLabel(size: 18, text: "How's it going?", textColor: .white)
        greetingLabel.textAlignment = .center
        return greetingLabel
    }()
    
    private lazy var nameTextField: NoBorderTextField = {
        let nameTextField = NoBorderTextField(bgColor: .clear, textColor: .white)
        nameTextField.font = UIFont.medium(size: 18)
        nameTextField.textAlignment = .center
        nameTextField.text = currentUser.name
        nameTextField.isUserInteractionEnabled = true
        nameTextField.addTarget(self, action: #selector(tapNameTextField), for: .touchUpInside)
        nameTextField.addTarget(self, action: #selector(nameEndEditing), for: .editingDidEnd)
        return nameTextField
    }()
    
    private lazy var furkidsTitleLabel: MediumLabel = {
        let furkidsTitleLabel = MediumLabel(size: 20, text: "Furkids", textColor: .mainBlue)
        return furkidsTitleLabel
    }()
    
    private lazy var addPetButton: IconButton = {
        let addPetButton = IconButton(self, action: #selector(tapAddPet), img: Img.iconsAdd)
        addPetButton.layer.borderWidth = 0
        return addPetButton
    }()
    
    private lazy var petTableView: UITableView = {
        let petTableView = UITableView()
        petTableView.register(PetTableViewCell.self, forCellReuseIdentifier: "PetTableViewCell")
        petTableView.separatorColor = .clear
        petTableView.backgroundColor = .white
        petTableView.estimatedRowHeight = 100
        petTableView.rowHeight = UITableView.automaticDimension
        petTableView.allowsSelection = true
        petTableView.delegate = self
        petTableView.dataSource = self
        petTableView.translatesAutoresizingMaskIntoConstraints = false
        return petTableView
    }()
    
    private lazy var firstImageView: UIImageView = {
        let firstImageView = UIImageView(image: Img.iconsPang.obj)
        firstImageView.translatesAutoresizingMaskIntoConstraints = false
        firstImageView.alpha = 0.2
        return firstImageView
    }()
    
    private lazy var guideCreateLabel: RegularLabel = {
        let guideCreateLabel = RegularLabel(size: 16, text: "Tap Plus button to create a pet group", textColor: .deepBlueGrey)
        guideCreateLabel.numberOfLines = 0
        return guideCreateLabel
    }()
    
    private lazy var secondImageView: UIImageView = {
        let secondImageView = UIImageView(image: Img.iconsPang.obj)
        secondImageView.translatesAutoresizingMaskIntoConstraints = false
        secondImageView.alpha = 0.2
        return secondImageView
    }()
    
    private lazy var guideGetInvitationLabel: RegularLabel = {
        let guideGetInvitationLabel = RegularLabel(size: 16, text: "Tap QR Code button to be invited", textColor: .deepBlueGrey)
        guideGetInvitationLabel.numberOfLines = 0
        return guideGetInvitationLabel
    }()
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PetTableViewCell.identifier, for: indexPath)
        guard let petCell = cell as? PetTableViewCell else { return cell }
        petCell.selectionStyle = .none
        petCell.reload(pet: pets[indexPath.row])
        return petCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPet = pets[indexPath.row]
        let editPetViewController = AddPetViewController(currentUser: MemberManager.shared.current ?? currentUser, selectedPet: selectedPet, isFirstSignIn: false)
        self.navigationController?.pushViewController(editPetViewController, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            self.presentDeleteAlert(title: "Delete furkid",
                                    message: "You'd need to be invited again, or you could not view previous info of this pet") { // action after user tapped delete
                // get the deleting pet
                let pet = self.pets[indexPath.row]
                
                // update deleted petIds
                MemberManager.shared.current?.petIds.removeAll { $0 == pet.id }
                MemberManager.shared.updateCurrentUser()
                
                // update that pet's memberIds
                pet.memberIds.removeAll { $0 == MemberManager.shared.current?.id }
                
                PetManager.shared.updatePet(id: pet.id, pet: pet) { result in
                    switch result {
                    case .success(let string):
                        print(string)

                    case .failure(let error):
                        self.presentErrorAlert(message: error.localizedDescription + " Please try again")
                    }
                }
            }
            
            completionHandler(true)
        }
        
        deleteAction.image = Img.iconsDelete.obj
        deleteAction.backgroundColor = .white
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

// MARK: - UI Configure Functions

extension ProfileViewController {
    
    private func configGreetingLabel() {
        view.addSubview(greetingLabel)
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            greetingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            greetingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configNameTextField() {
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 4),
            nameTextField.heightAnchor.constraint(equalToConstant: 32),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 2)
        ])
    }
    
    private func configCardView() {
        view.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 12),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configFurKidLabel() {
        view.addSubview(furkidsTitleLabel)
        NSLayoutConstraint.activate([
            furkidsTitleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 40),
            furkidsTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            furkidsTitleLabel.widthAnchor.constraint(equalToConstant: 78)
        ])
    }
    
    private func configAddPetButton() {
        view.addSubview(addPetButton)
        NSLayoutConstraint.activate([
            addPetButton.centerYAnchor.constraint(equalTo: furkidsTitleLabel.centerYAnchor),
            addPetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            addPetButton.widthAnchor.constraint(equalToConstant: 50),
            addPetButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configPetTableView() {
        view.addSubview(petTableView)
        NSLayoutConstraint.activate([
            petTableView.topAnchor.constraint(equalTo: furkidsTitleLabel.bottomAnchor, constant: 30),
            petTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            petTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            petTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
    private func configFirstImageView() {
        view.addSubview(firstImageView)
        NSLayoutConstraint.activate([
            firstImageView.topAnchor.constraint(equalTo: furkidsTitleLabel.bottomAnchor, constant: 48),
            firstImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            firstImageView.widthAnchor.constraint(equalToConstant: 25),
            firstImageView.heightAnchor.constraint(equalTo: firstImageView.widthAnchor)
        ])
    }
    
    private func configGuideCreateLabel() {
        view.addSubview(guideCreateLabel)
        NSLayoutConstraint.activate([
            guideCreateLabel.topAnchor.constraint(equalTo: firstImageView.topAnchor),
            guideCreateLabel.leadingAnchor.constraint(equalTo: firstImageView.trailingAnchor, constant: 20),
            guideCreateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configSecondImageView() {
        view.addSubview(secondImageView)
        NSLayoutConstraint.activate([
            secondImageView.topAnchor.constraint(equalTo: guideCreateLabel.bottomAnchor, constant: 24),
            secondImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            secondImageView.widthAnchor.constraint(equalToConstant: 25),
            secondImageView.heightAnchor.constraint(equalTo: secondImageView.widthAnchor)
        ])
    }

    private func configGuideInvitationLabel() {
        view.addSubview(guideGetInvitationLabel)
        NSLayoutConstraint.activate([
            guideGetInvitationLabel.topAnchor.constraint(equalTo: secondImageView.topAnchor),
            guideGetInvitationLabel.leadingAnchor.constraint(equalTo: secondImageView.trailingAnchor, constant: 20),
            guideGetInvitationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
}
