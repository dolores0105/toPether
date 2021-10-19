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
    
    let petProvider = PetProvider()
    var pets = [Pet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        petProvider.setPetData()
        petProvider.fetchPetData { [weak self] result in
            switch result {
            case .success(let pets):
                guard let self = self else { return }
                self.pets = pets
                self.petCollectionView.reloadData()
                print("fetch:", self.pets)
            case .failure(let error):
                print(error)
            }
        }
        
        
        // MARK: Navigation controller
        self.navigationItem.title = "toPether"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: 24)]
        
        // MARK: UI objects layout
        let petsLayout = UICollectionViewFlowLayout()
        petsLayout.sectionInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        petsLayout.minimumLineSpacing = 20
        petsLayout.minimumInteritemSpacing = 20
        petsLayout.scrollDirection = .horizontal
        petsLayout.itemSize.width = view.bounds.width - 64
        petsLayout.itemSize.height = view.bounds.height / 3 * 2
        
        petCollectionView = UICollectionView(frame: .zero, collectionViewLayout: petsLayout)
        petCollectionView.backgroundColor = .clear
        petCollectionView.showsHorizontalScrollIndicator = false
        petCollectionView.bounces = false
        petCollectionView.register(PetCollectionViewCell.self, forCellWithReuseIdentifier: "PetCollectionViewCell")
        petCollectionView.delegate = self
        petCollectionView.dataSource = self
        
        petCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(petCollectionView)
        NSLayoutConstraint.activate([
            petCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            petCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            petCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            petCollectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 2 / 3)
        ])
        
        view.addSubview(buttonStackView)
        let buttons = [
            IconButton(self, action: #selector(tapXXXButton), img: .iconsFoodRecords),
            IconButton(self, action: #selector(tapXXXButton), img: .iconsGallery),
            IconButton(self, action: #selector(tapXXXButton), img: .iconsGenderMale),
            IconButton(self, action: #selector(tapXXXButton), img: .iconsMessage),
        ]
        buttons.forEach { button in
            buttonStackView.addArrangedSubview(button)
        }
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: petCollectionView.bottomAnchor, constant: 20),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64),
            buttonStackView.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    
    // MARK: functions
    @objc private func tapXXXButton(_: BorderButton) {
        //switch
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
            
//            guard let jpegData06decodedData = NSData(base64Encoded: pets[indexPath.item].photo, options: NSData.Base64DecodingOptions()),
//                    let decodedImage = UIImage(data: jpegData06decodedData as Data) else { return petCell }
//            let petImage = decodedImage as UIImage
//            
//            petCell.petImageView.image = petImage
        petCell.reload(pet: pets[indexPath.item])
        return petCell

    }
}

extension HomeViewController: UICollectionViewDelegate {

}
