//
//  ViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/18.
//

import UIKit

class HomeViewController: UIViewController {
    
    var petPhotosCollectionView: UICollectionView!
    var fakeView: UIView! // for collectionView
    var blueBorderView: UIView!
    var petName: UILabel!
    var petAge: UILabel!
    var genderImageView: UIImageView!
    var membersCollectionView: UICollectionView!
    var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Navigation controller
        self.navigationItem.title = "toPether"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: 24)]
        
        let petsLayout = UICollectionViewFlowLayout()
        petsLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        petsLayout.minimumLineSpacing = 4
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
        
        blueBorderView = UIView()
        blueBorderView.backgroundColor = .white
        blueBorderView.layer.borderWidth = 1
        blueBorderView.layer.borderColor = UIColor.mainBlue.cgColor
        blueBorderView.layer.cornerRadius = 10
        blueBorderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blueBorderView)
        NSLayoutConstraint.activate([
            blueBorderView.topAnchor.constraint(equalTo: petPhotosCollectionView.bottomAnchor, constant: 20),
            blueBorderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            blueBorderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            blueBorderView.heightAnchor.constraint(equalToConstant: 84)
        ])
        
        petName = UILabel()
        petName.text = "Ronaldo"
        petName.font = UIFont.medium(size: 22)
        petName.textColor = .mainBlue
        petName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(petName)
        NSLayoutConstraint.activate([
            petName.topAnchor.constraint(equalTo: blueBorderView.topAnchor, constant: 16),
            petName.leadingAnchor.constraint(equalTo: blueBorderView.leadingAnchor, constant: 16),
            petName.trailingAnchor.constraint(equalTo: blueBorderView.trailingAnchor, constant: -16),
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
            petAge.leadingAnchor.constraint(equalTo: blueBorderView.leadingAnchor, constant: 16),
            petAge.widthAnchor.constraint(equalTo: blueBorderView.widthAnchor, multiplier: 0.5),
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
            genderImageView.trailingAnchor.constraint(equalTo: blueBorderView.trailingAnchor, constant: -16),
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
            membersCollectionView.topAnchor.constraint(equalTo: blueBorderView.bottomAnchor, constant: 20),
            membersCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            membersCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64),
            membersCollectionView.heightAnchor.constraint(equalToConstant: 28)
        ])

        button = UIButton()
        button.layer.borderColor = UIColor.mainBlue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: membersCollectionView.bottomAnchor, constant: 24),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            button.heightAnchor.constraint(equalToConstant: 64),
            button.widthAnchor.constraint(equalToConstant: 64)
        ])
    }

}

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
            return 4
        case membersCollectionView:
            return 10
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.petPhotosCollectionView {
            let petCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetPhotoCollectionViewCell", for: indexPath)
            guard let petCell = petCell as? PetPhotoCollectionViewCell else { return petCell }

            switch indexPath.item {
            case 0:
                petCell.backgroundColor = .mainBlue
            case 1:
                petCell.backgroundColor = .mainBlue
            case 2:
                petCell.backgroundColor = .mainBlue
            case 3:
                petCell.backgroundColor = .mainBlue
            default:
                petCell.backgroundColor = .mainBlue
            }

            return petCell
            
        } else {
            let memberCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberNamesCollectionViewCell", for: indexPath)
            guard let memberCell = memberCell as? MemberNamesCollectionViewCell else { return memberCell }
//            memberCell.backgroundColor = .orange
            return memberCell
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {

}
