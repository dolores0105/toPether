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
    
    override func viewWillAppear(_ animated: Bool) {
        // MARK: Navigation controller
        self.navigationItem.title = "toPether"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: 24)]
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            }
        }
        
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
            IconButton(self, action: #selector(tapXXXButton), img: .iconsFood),
            IconButton(self, action: #selector(tapMedicalButton), img: .iconsMedicalRecords),
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
    @objc private func tapMedicalButton(_: BorderButton) {
        let medicalVC = MedicalViewController(selectedPet: self.pets[petIndex])
        navigationController?.pushViewController(medicalVC, animated: true)
    }
    
    @objc private func tapXXXButton(_: BorderButton) {
        // switch
    }
    
    func queryData(currentUser: Member) {
        PetModel.shared.queryPets(ids: currentUser.petIds) { [weak self] result in
            switch result {
            case .success(let pets):
                guard let self = self else { return }
                self.pets = pets
                self.petCollectionView.reloadData()
                print("fetch pets at profile:", self.pets)
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

extension HomeViewController: PetCollectionViewCellDelegate {
    func pushToInviteVC(pet: Pet) {
        let inviteVC = InviteViewController(pet: pet)
        self.navigationController?.pushViewController(inviteVC, animated: true)
    }
}
