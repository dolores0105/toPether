//
//  PetPhotoCollectionViewCell.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/18.
//
// swiftlint:disable function_body_length

import UIKit
import Firebase
import FirebaseFirestore

protocol PetCollectionViewCellDelegate: AnyObject {
    func pushToInviteVC(pet: Pet)
}

class PetCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: PetCollectionViewCellDelegate?

    private var petImageView: RoundCornerImageView!
    
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
    
    private var listener: ListenerRegistration?
    var pet: Pet?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        petImageView = RoundCornerImageView(img: nil)
        contentView.addSubview(petImageView)
        NSLayoutConstraint.activate([
            petImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            petImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            petImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            petImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1 / 2, constant: 50)
        ])
        
        petInfoButton = BorderButton()
        petInfoButton.setShadow(color: .mainBlue, offset: CGSize(width: 3.0, height: 3.0), opacity: 0.1, radius: 6)
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapStackView))
        memberStackView.addGestureRecognizer(tap)
        contentView.addSubview(memberStackView)
        NSLayoutConstraint.activate([
            memberStackView.topAnchor.constraint(equalTo: petInfoButton.bottomAnchor, constant: 16),
            memberStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        addMemberButton = CircleButton(name: "")
        addMemberButton.backgroundColor = .mainYellow
        addMemberButton.layer.borderColor = UIColor.lightBlueGrey.cgColor
        addMemberButton.setImage(Img.iconsAddWhite.obj, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reload(pet: Pet) {
//        updateCell(pet: pet, members: members)
        
        self.pet = pet // initialize pet for reloading each time
        addListener(pet: pet)
    }
    
    func updateCell(pet: Pet, members: [Member]) {
        self.pet = pet
        petImageView.image = pet.photoImage
        petName.text = pet.name
        petAge.text = pet.ageInfo
        
        if pet.gender == "male" {
            genderImageView.image = Img.iconsGenderMale.obj
        } else {
            genderImageView.image = Img.iconsGenderFemale.obj
        }

        memberStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        updateMembers(members)
    }
    
    func addListener(pet: Pet) {
        listener?.remove() // remove instance listener, Stop listening to changes

        listener = PetModel.shared.addPetListener(pet: pet, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let pet):
                
                // self.pet?.memberIds.count != pet.memberIds.count &&
                if !pet.memberIds.isEmpty {
                    MemberModel.shared.queryMembers(ids: pet.memberIds) { [weak self] result in
                        switch result {
                        case .success(let members):
                            guard let self = self else { return }

                            self.updateCell(pet: pet, members: members)
                            
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                
            case .failure(let error):
                print("addListener error", error)
            }
        })
    }
    
    private func updateMembers(_ members: [Member]) {
        members.forEach { member in
            circleButton = CircleButton(name: member.name.first?.description ?? "")
            circleButton.layer.cornerRadius = 32 / 2
            NSLayoutConstraint.activate([
                circleButton.heightAnchor.constraint(equalToConstant: 32),
                circleButton.widthAnchor.constraint(equalToConstant: 32)
            ])
            memberStackView.addArrangedSubview(circleButton)
            circleButton.isUserInteractionEnabled = false
        }
        addMemberButton.layer.cornerRadius = 32 / 2
        NSLayoutConstraint.activate([
            addMemberButton.heightAnchor.constraint(equalToConstant: 32),
            addMemberButton.widthAnchor.constraint(equalToConstant: 32)
        ])
        memberStackView.addArrangedSubview(addMemberButton)
        addMemberButton.isUserInteractionEnabled = false
    }
    
    @objc func tapStackView(sender: AnyObject) {
        guard let pet = pet else { return }
        delegate?.pushToInviteVC(pet: pet)
    }
}
