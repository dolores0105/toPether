//
//  ViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/18.
//

import UIKit
import Photos

class HomeViewController: UIViewController {
    
    private lazy var cardView: CardView = {
        let cardView = CardView(color: .white, cornerRadius: 20)
        return cardView
    }()
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionViewFlowLayout.minimumLineSpacing = 0
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.itemSize.width = view.bounds.width
        collectionViewFlowLayout.itemSize.height = view.bounds.height / 3 * 2
        return collectionViewFlowLayout
    }()
    
    private lazy var petCollectionView: UICollectionView = {
        let petCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        petCollectionView.backgroundColor = .clear
        petCollectionView.showsHorizontalScrollIndicator = false
        petCollectionView.bounces = true
        petCollectionView.allowsSelection = false
        petCollectionView.isPagingEnabled = true
        petCollectionView.register(PetCollectionViewCell.self, forCellWithReuseIdentifier: "PetCollectionViewCell")
        petCollectionView.delegate = self
        petCollectionView.dataSource = self
        petCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return petCollectionView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 28
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var emptyTitleLabel: MediumLabel = {
        let emptyTitleLabel = MediumLabel(size: 20, text: "Oh...\nYou haven’t in a pet group", textColor: .deepBlueGrey)
        emptyTitleLabel.textAlignment = .center
        emptyTitleLabel.numberOfLines = 0
        return emptyTitleLabel
    }()
    
    private lazy var emptyContentLabel: RegularLabel = {
        let emptyContentLabel = RegularLabel(size: 18, text: "Go profile page \nfor creating one or getting invited", textColor: .deepBlueGrey)
        emptyContentLabel.textAlignment = .center
        emptyContentLabel.numberOfLines = 0
        return emptyContentLabel
    }()
    
    private lazy var emptyAnimationView = LottieAnimation.shared.createLoopAnimation(lottieName: "lottieDogSitting")

    private var pets = [Pet]()
    private var currentUser: Member! = MemberModel.shared.current
    private var petIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainBlue
        configCardView()
        configCollectionView()
        configButtonStackView()
        
        queryData(currentUser: currentUser)
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
                self.presentErrorAlert(title: "Something went wrong", message: error.localizedDescription + " Please try again")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        self.navigationItem.title = "toPether"
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - functions
    
    @objc private func tapMessageButton(_: BorderButton) {
        let messageVC = MessageViewController(selectedPet: self.pets[petIndex])
        navigationController?.pushViewController(messageVC, animated: true)
    }
    
    @objc private func tapFoodButton(_: BorderButton) {
        let foodVC = FoodViewController(selectedPet: self.pets[petIndex])
        navigationController?.pushViewController(foodVC, animated: true)
    }
    
    @objc private func tapMedicalButton(_: BorderButton) {
        let medicalVC = MedicalViewController(selectedPet: self.pets[petIndex])
        navigationController?.pushViewController(medicalVC, animated: true)
    }
    
    @objc private func tapXXXButton(_ sender: BorderButton) {
        // switch
    }
    
    func queryData(currentUser: Member) {
        PetModel.shared.queryPets(ids: currentUser.petIds) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let pets):
                self.pets = pets
                self.petCollectionView.reloadData()
                print("fetch pets at profile:", self.pets)
                self.buttonStackView.isHidden = false
                self.emptyTitleLabel.removeFromSuperview()
                self.emptyContentLabel.removeFromSuperview()
                self.emptyAnimationView.removeFromSuperview()
                
            case .failure(let error):
                print(error)
                self.buttonStackView.isHidden = true
                self.configEmptyTitleLabel()
                self.configEmptyContentLabel()
                self.configEmptyAnimation()
            }
        }
    }
    
    func authorizeCamera() -> Bool {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        let inviteVC = InviteViewController(pet: self.pets[self.petIndex])
                        self.navigationController?.pushViewController(inviteVC, animated: true)
                        _ = self.authorizeCamera()
                    }
                }
            }
        case .restricted, .denied:
            presentGoSettingAlert()
            
        case .authorized:
            return true
            
        @unknown default:
            presentGoSettingAlert()
        }
        
        return false
    }
    
    func presentGoSettingAlert() {
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "toPether would like to access the Camera", message: "Please turn on the setting for scanning members' QRCode", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let settingAction = UIAlertAction(title: "Setting", style: .default) { settingAction in
                guard let settingUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingUrl, options: [:], completionHandler: { (success) in
                        print("跳至設定")
                    })
                } else {
                    UIApplication.shared.openURL(settingUrl)
                }
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(settingAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - CollectionViewDelegate+DataSource

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetCollectionViewCell", for: indexPath)
        guard let petCell = cell as? PetCollectionViewCell else { return cell }

        petCell.reload(pet: self.pets[indexPath.item])

        petCell.delegate = self
        
        return petCell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = petCollectionView.visibleCells.first, let index = petCollectionView.indexPath(for: cell)?.row else { return }
        
        petIndex = index
        print("current index by didEndDisplaying:", petIndex)
    }
}

// MARK: - CellDelegate

extension HomeViewController: PetCollectionViewCellDelegate {
    
    func pushToInviteVC(pet: Pet) {
        if authorizeCamera() {
            let inviteVC = InviteViewController(pet: pet)
            self.navigationController?.pushViewController(inviteVC, animated: true)
        }
    }
}

// MARK: - UI settings

extension HomeViewController {
    
    private func configCardView() {
        view.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configCollectionView() {
        view.addSubview(petCollectionView)
        NSLayoutConstraint.activate([
            petCollectionView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            petCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            petCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            petCollectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 3 / 4, constant: 32)
        ])
    }
    
    private func configButtonStackView() {
        view.addSubview(buttonStackView)
        
        let buttons = [
            IconButton(self, action: #selector(tapMessageButton), img: .iconsMessage),
            IconButton(self, action: #selector(tapFoodButton), img: .iconsFood),
            IconButton(self, action: #selector(tapMedicalButton), img: .iconsMedicalRecords)
        ]
        
        buttons.forEach { button in
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 56),
                button.widthAnchor.constraint(equalToConstant: 72)
            ])
            button.setShadow(color: .mainBlue, offset: CGSize(width: 3.0, height: 3.0), opacity: 0.1, radius: 6)
            
            buttonStackView.addArrangedSubview(button)
        }
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: petCollectionView.bottomAnchor, constant: 8),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configEmptyTitleLabel() {
        view.addSubview(emptyTitleLabel)
        NSLayoutConstraint.activate([
            emptyTitleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 120),
            emptyTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configEmptyContentLabel() {
        view.addSubview(emptyContentLabel)
        NSLayoutConstraint.activate([
            emptyContentLabel.topAnchor.constraint(equalTo: emptyTitleLabel.bottomAnchor, constant: 16),
            emptyContentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyContentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configEmptyAnimation() {
        view.addSubview(emptyAnimationView)
        NSLayoutConstraint.activate([
            emptyAnimationView.topAnchor.constraint(equalTo: emptyContentLabel.bottomAnchor, constant: 24),
            emptyAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyAnimationView.widthAnchor.constraint(equalToConstant: 120),
            emptyAnimationView.heightAnchor.constraint(equalTo: emptyAnimationView.widthAnchor)
        ])
    }
    
}
