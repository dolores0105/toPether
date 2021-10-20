//
//  PetPhotoCollectionViewCell.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/18.
//
// swiftlint:disable function_body_length

import UIKit

class PetCollectionViewCell: UICollectionViewCell {

    
    private var petImageView: UIImageView!
    
    private var petInfoButton: BorderButton!
    private var petName: UILabel!
    private var petAge: UILabel!
    private var genderImageView: UIImageView!
    
    private let memberStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var circleButton: CircleButton!
    private var addMemberButton: CircleButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        petImageView = UIImageView()
        petImageView.backgroundColor = .orange
//        petImageView.layer.cornerRadius = 10
        petImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(petImageView)
        
        NSLayoutConstraint.activate([
            
            petImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            petImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            petImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -64),
            petImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1 / 2, constant: 50)
            
        ])
        
        petInfoButton = BorderButton()
        contentView.addSubview(petInfoButton)
        NSLayoutConstraint.activate([
            petInfoButton.topAnchor.constraint(equalTo: petImageView.bottomAnchor, constant: 20),
            petInfoButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            petInfoButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -64),
            petInfoButton.heightAnchor.constraint(equalToConstant: 84)
        ])
        
        petName = UILabel()
        petName.font = UIFont.medium(size: 22)
        petName.textColor = .mainBlue
        petName.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(petName)
        NSLayoutConstraint.activate([
            petName.topAnchor.constraint(equalTo: petInfoButton.topAnchor, constant: 16),
            petName.leadingAnchor.constraint(equalTo: petInfoButton.leadingAnchor, constant: 16),
            petName.trailingAnchor.constraint(equalTo: petInfoButton.trailingAnchor, constant: -16),
            petName.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        petAge = UILabel()
        petAge.textColor = .deepBlueGrey
        petAge.font = UIFont.regular(size: 18)
        petAge.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(petAge)
        NSLayoutConstraint.activate([
            petAge.topAnchor.constraint(equalTo: petName.bottomAnchor, constant: 4),
            petAge.leadingAnchor.constraint(equalTo: petInfoButton.leadingAnchor, constant: 16),
            petAge.widthAnchor.constraint(equalTo: petInfoButton.widthAnchor, multiplier: 0.5),
            petAge.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        genderImageView = UIImageView()
        genderImageView.contentMode = .scaleAspectFill
        genderImageView.clipsToBounds = true
        genderImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(genderImageView)
        NSLayoutConstraint.activate([
            genderImageView.centerYAnchor.constraint(equalTo: petAge.centerYAnchor),
            genderImageView.trailingAnchor.constraint(equalTo: petInfoButton.trailingAnchor, constant: -16),
            genderImageView.widthAnchor.constraint(equalToConstant: 22),
            genderImageView.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        contentView.addSubview(memberStackView)
        NSLayoutConstraint.activate([
            memberStackView.topAnchor.constraint(equalTo: petInfoButton.bottomAnchor, constant: 16),
            memberStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        addMemberButton = CircleButton(name: "")
        addMemberButton.backgroundColor = .mainYellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reload(pet: Pet, members: [Member]) {
        petImageView.image = pet.photoImage
        petAge.text = pet.birthday.description
        petName.text = pet.petName
        if pet.petGender == "male" {
            genderImageView.image = Img.iconsGenderMale.obj
        } else {
            genderImageView.image = Img.iconsGenderFemale.obj
        }

        memberStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        updateMembers(members)
    }
    
    private func updateMembers(_ members: [Member]) {
        members.forEach { member in
            circleButton = CircleButton(name: member.memberName.first?.description ?? "")
            memberStackView.addArrangedSubview(circleButton)
        }
        memberStackView.addArrangedSubview(addMemberButton)
    }
}
