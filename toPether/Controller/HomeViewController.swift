//
//  ViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/18.
//
// swiftlint:disable function_body_length
import UIKit

class HomeViewController: UIViewController {
    
    var petCollectionView: UICollectionView!
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    var pets = [Pet]()
    var currentUser: Member! = MemberModel.shared.current
    var members = [Member]()
    var petIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let userId = self.user.userId else { return }
//        memberModel.setMember()
//        MemberModel.shared.setMember(name: "Lucy")
        queryData()
        MemberModel.shared.addUserListener { [weak self] _ in
            self?.queryData()
        }
        
        // MARK: Navigation controller
        self.navigationItem.title = "toPether"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: 24)]
        
        // MARK: UI objects layout
        let petsLayout = UICollectionViewFlowLayout()
        petsLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        petsLayout.minimumLineSpacing = 0
        petsLayout.minimumInteritemSpacing = 0
        petsLayout.scrollDirection = .horizontal
        petsLayout.itemSize.width = view.bounds.width
        petsLayout.itemSize.height = view.bounds.height / 3 * 2
        
        petCollectionView = UICollectionView(frame: .zero, collectionViewLayout: petsLayout)
        petCollectionView.backgroundColor = .clear
        petCollectionView.showsHorizontalScrollIndicator = false
        petCollectionView.bounces = false
        petCollectionView.allowsSelection = false
        petCollectionView.isPagingEnabled = true
        petCollectionView.register(PetCollectionViewCell.self, forCellWithReuseIdentifier: "PetCollectionViewCell")
        petCollectionView.delegate = self
        petCollectionView.dataSource = self
        
        petCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(petCollectionView)
        NSLayoutConstraint.activate([
            petCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            petCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            petCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            petCollectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 3 / 4)
        ])
        
        view.addSubview(buttonStackView)
        let buttons = [
            IconButton(self, action: #selector(tapXXXButton), img: .iconsMessage),
            IconButton(self, action: #selector(tapXXXButton), img: .iconsFoodRecords),
            IconButton(self, action: #selector(tapXXXButton), img: .iconsMedicalRecords),
            IconButton(self, action: #selector(tapXXXButton), img: .iconsGallery)
        ]
        buttons.forEach { button in
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 64),
                button.widthAnchor.constraint(equalToConstant: 64)
            ])
            buttonStackView.addArrangedSubview(button)
        }
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: petCollectionView.bottomAnchor, constant: 20),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: functions
    @objc private func tapXXXButton(_: BorderButton) {
        // switch
    }
    
    func queryData() {
        PetModel.shared.queryPets(ids: currentUser.petIds) { [weak self] result in
            switch result {
            case .success(let pets):
                guard let self = self else { return }
                self.pets = pets
                self.petCollectionView.reloadData()
                print("fetch pets:", self.pets)
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: Extension
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let petCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetCollectionViewCell", for: indexPath)
        guard let petCell = petCell as? PetCollectionViewCell else { return petCell }
        
        if case let memberIds = pets[indexPath.item].memberIds, !memberIds.isEmpty {
            MemberModel.shared.queryMembers(ids: memberIds) { [weak self] result in
                switch result {
                case .success(let members):
                    guard let self = self else { return }
                    self.members = members
                    print("fetch members:", self.members)
                    petCell.reload(pet: self.pets[indexPath.item], members: members)
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        _ = PetModel.shared.addPetListener(pet: pets[indexPath.item]) { [weak self] result in
            switch result {
            case .success(let pet):
                guard let self = self else { return }
                petCell.addListener(pet: pet, members: self.members)
            case .failure(let error):
                print("add petListener error:", error)
            }
        }
        
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
