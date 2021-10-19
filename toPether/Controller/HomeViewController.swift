//
//  ViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/18.
//
// swiftlint:disable function_body_length
import UIKit

class HomeViewController: UIViewController {
    
    var petPhotosCollectionView: UICollectionView!
    var fakeView: UIView! // for collectionView
    var petInfoButton: BorderButton!
    var petName: UILabel!
    var petAge: UILabel!
    var genderImageView: UIImageView!
    var membersCollectionView: UICollectionView!
    var button: BorderButton!
    let iconsOfButtons: [String] = ["icons_message.png", "icons_foodRecords.png", "icons_medicalRecords.png", "icons_gallery.png"]
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
                self.reloadData(pet: self.pets)
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
        petsLayout.itemSize.height = view.bounds.height / 2
        
        petPhotosCollectionView = UICollectionView(frame: .zero, collectionViewLayout: petsLayout)
        petPhotosCollectionView.backgroundColor = .clear
        petPhotosCollectionView.showsHorizontalScrollIndicator = false
        petPhotosCollectionView.bounces = false
        petPhotosCollectionView.register(PetPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PetPhotoCollectionViewCell")
        petPhotosCollectionView.delegate = self
        petPhotosCollectionView.dataSource = self
        
        petPhotosCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(petPhotosCollectionView)
        NSLayoutConstraint.activate([
            petPhotosCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            petPhotosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            petPhotosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            petPhotosCollectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)
        ])
        
        
        petInfoButton = BorderButton()
        view.addSubview(petInfoButton)
        NSLayoutConstraint.activate([
            petInfoButton.topAnchor.constraint(equalTo: petPhotosCollectionView.bottomAnchor, constant: 20),
            petInfoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            petInfoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            petInfoButton.heightAnchor.constraint(equalToConstant: 84)
        ])
        
        
        petName = UILabel()
        petName.text = "Ronaldo"
        petName.font = UIFont.medium(size: 22)
        petName.textColor = .mainBlue
        petName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(petName)
        NSLayoutConstraint.activate([
            petName.topAnchor.constraint(equalTo: petInfoButton.topAnchor, constant: 16),
            petName.leadingAnchor.constraint(equalTo: petInfoButton.leadingAnchor, constant: 16),
            petName.trailingAnchor.constraint(equalTo: petInfoButton.trailingAnchor, constant: -16),
            petName.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        
        petAge = UILabel()
        petAge.text = "5y 3m"
        petAge.textColor = .deepBlueGrey
        petAge.font = UIFont.regular(size: 18)
        petAge.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(petAge)
        NSLayoutConstraint.activate([
            petAge.topAnchor.constraint(equalTo: petName.bottomAnchor, constant: 4),
            petAge.leadingAnchor.constraint(equalTo: petInfoButton.leadingAnchor, constant: 16),
            petAge.widthAnchor.constraint(equalTo: petInfoButton.widthAnchor, multiplier: 0.5),
            petAge.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        
        genderImageView = UIImageView()
        genderImageView.contentMode = .scaleAspectFill
        genderImageView.clipsToBounds = true
        genderImageView.image = UIImage(named: "icons_gender_male.png")
        genderImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(genderImageView)
        NSLayoutConstraint.activate([
            genderImageView.centerYAnchor.constraint(equalTo: petAge.centerYAnchor),
            genderImageView.trailingAnchor.constraint(equalTo: petInfoButton.trailingAnchor, constant: -16),
            genderImageView.widthAnchor.constraint(equalToConstant: 22),
            genderImageView.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        
        let membersLayout = UICollectionViewFlowLayout()
        membersLayout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        membersLayout.minimumLineSpacing = 8
        membersLayout.minimumInteritemSpacing = 8
        membersLayout.itemSize = CGSize(width: 24, height: 24)

        membersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: membersLayout)
        membersCollectionView.register(MemberNamesCollectionViewCell.self, forCellWithReuseIdentifier: "MemberNamesCollectionViewCell")
        membersCollectionView.delegate = self
        membersCollectionView.dataSource = self

        membersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(membersCollectionView)
        NSLayoutConstraint.activate([
            membersCollectionView.topAnchor.constraint(equalTo: petInfoButton.bottomAnchor, constant: 20),
            membersCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            membersCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64),
            membersCollectionView.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        
        view.addSubview(buttonStackView)
        iconsOfButtons.forEach { (icons) in
            button = BorderButton()
            button.imageView?.contentMode = .scaleAspectFill
            button.clipsToBounds = true
            if #available(iOS 15.0, *) {
                var configuration = UIButton.Configuration.filled()
                configuration.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            } else {
                button.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            }
            button.setImage(UIImage(named: icons), for: .normal)
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 64),
                button.widthAnchor.constraint(equalToConstant: 64)
            ])
            buttonStackView.addArrangedSubview(button)
        }
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: membersCollectionView.bottomAnchor, constant: 24),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
        ])
    }
    
    // MARK: functions
    func reloadData(pet: [Pet]) {
        self.petPhotosCollectionView.reloadData()
        self.petName.text = pet[0].petName
        self.petAge.text = String(pet[0].birthday)
        if pet[0].petGender == "male" {
            self.genderImageView.image = UIImage(named: "icons_gender_male.png")
        } else {
            self.genderImageView.image = UIImage(named: "icons_gender_female.png")
        }
        self.membersCollectionView.reloadData()
    }
    
}

// MARK: Extension
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        case petPhotosCollectionView:
            return 1
        case membersCollectionView:
            return 1
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case petPhotosCollectionView:
            return self.pets.count
        case membersCollectionView:
            return 1 // max number of layout in SE2 (members max == 8)
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.petPhotosCollectionView {
            let petCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetPhotoCollectionViewCell", for: indexPath)
            guard let petCell = petCell as? PetPhotoCollectionViewCell else { return petCell }
            
            guard let jpegData06decodedData = NSData(base64Encoded: pets[indexPath.item].photo, options: NSData.Base64DecodingOptions()),
                    let decodedImage = UIImage(data: jpegData06decodedData as Data) else { return petCell }
            let petImage = decodedImage as UIImage
            
            petCell.imageView.image = petImage
            
            return petCell
            
        } else {
            let memberCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberNamesCollectionViewCell", for: indexPath)
            guard let memberCell = memberCell as? MemberNamesCollectionViewCell else { return memberCell }

            switch indexPath.item {
            case 0..<2:
                memberCell.configNameLabel()
            default:
                memberCell.configAddMemberButton()
            }
            return memberCell
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {

}
