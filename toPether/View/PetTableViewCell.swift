//
//  PetTableViewCell.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/20.
//

import UIKit
import Firebase
import FirebaseFirestore

class PetTableViewCell: UITableViewCell {
    
    private var borderView: BorderView!
    private var petImageView: RoundCornerImageView!
    private var nameLabel: MediumLabel!
    private var genderImageView: UIImageView!
    private var ageLabel: RegularLabel!
    private var memberNumberButton: UIButton!
    private var editImageView: UIImageView!
    
    private var listener: ListenerRegistration?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        borderView = BorderView()
        borderView.backgroundColor = .white
        borderView.setShadow(color: .mainBlue, offset: CGSize(width: 3.0, height: 3.0), opacity: 0.1, radius: 6)
        contentView.addSubview(borderView)
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            borderView.heightAnchor.constraint(equalToConstant: 80),
            borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        petImageView = RoundCornerImageView(img: nil)
        contentView.addSubview(petImageView)
        NSLayoutConstraint.activate([
            petImageView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -12),
            petImageView.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 12),
            petImageView.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 12),
            petImageView.widthAnchor.constraint(equalTo: petImageView.heightAnchor)
        ])
        
        nameLabel = MediumLabel(size: 18, text: nil, textColor: .mainBlue)
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: petImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -16)
        ])
        
        genderImageView = UIImageView()
        genderImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(genderImageView)
        NSLayoutConstraint.activate([
            genderImageView.bottomAnchor.constraint(equalTo: petImageView.bottomAnchor),
            genderImageView.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 16),
            genderImageView.heightAnchor.constraint(equalToConstant: 20),
            genderImageView.widthAnchor.constraint(equalTo: genderImageView.heightAnchor)
        ])
        
        ageLabel = RegularLabel(size: 14, text: nil, textColor: .deepBlueGrey)
        contentView.addSubview(ageLabel)
        NSLayoutConstraint.activate([
            ageLabel.centerYAnchor.constraint(equalTo: genderImageView.centerYAnchor),
            ageLabel.leadingAnchor.constraint(equalTo: genderImageView.trailingAnchor, constant: 8),
            ageLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        editImageView = UIImageView(image: Img.iconsEdit.obj)
        editImageView.alpha = 0.1
        editImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(editImageView)
        NSLayoutConstraint.activate([
            editImageView.centerYAnchor.constraint(equalTo: borderView.centerYAnchor),
            editImageView.heightAnchor.constraint(equalToConstant: 32),
            editImageView.widthAnchor.constraint(equalTo: editImageView.heightAnchor),
            editImageView.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload(pet: Pet) {
        updateCell(pet: pet)
        
        addListener(pet: pet)
    }
    
    func updateCell(pet: Pet) {
        petImageView.image = pet.photoImage
        nameLabel.text = pet.name
        ageLabel.text = pet.ageInfo
        
        if pet.gender == "male" {
            genderImageView.image = Img.iconsGenderMale.obj
        } else {
            genderImageView.image = Img.iconsGenderFemale.obj
        }
    }
    
    func addListener(pet: Pet) {
            listener?.remove()
        
            listener = PetManager.shared.addPetListener(pet: pet, completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let pet):
                    self.updateCell(pet: pet)

                case .failure(let error):
                    print("addListener error", error)
                }
                
            })
    }
}
