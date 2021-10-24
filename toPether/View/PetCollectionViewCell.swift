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
    
    private var listener: ListenerRegistration?
    private var lastpet: Pet?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        petImageView = UIImageView()
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
        addMemberButton.setImage(Img.iconsAddWhite.obj, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reload(pet: Pet, members: [Member]) {
        updateCell(pet: pet, members: members)
        
        addListener(pet: pet, members: members)
    }
    
    func updateCell(pet: Pet, members: [Member]) {
        petImageView.image = pet.photoImage
        petName.text = pet.name
        
        var year: Int?
        var month: Int?
        (year, month) = getYearMonth(from: pet.birthday)
        guard let year = year, let month = month else { return }
        petAge.text = "\(year)y  \(month)m"
        
        if pet.gender == "male" {
            genderImageView.image = Img.iconsGenderMale.obj
        } else {
            genderImageView.image = Img.iconsGenderFemale.obj
        }

        memberStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        updateMembers(members)
    }
    
    func addListener(pet: Pet, members: [Member]) {
            listener?.remove() // remove instance listener, Stop listening to changes
        // add pet listener
            listener = PetModel.shared.addPetListener(pet: pet, completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let pet):
                    self.updateCell(pet: pet, members: members)
                    print("reload collection cell")
                case .failure(let error):
                    print("addListener error", error)
                }
                
            })
    }
    
    private func updateMembers(_ members: [Member]) {
        members.forEach { member in
            circleButton = CircleButton(name: member.name.first?.description ?? "")
            circleButton.layer.cornerRadius = 28 / 2
            NSLayoutConstraint.activate([
                circleButton.heightAnchor.constraint(equalToConstant: 28),
                circleButton.widthAnchor.constraint(equalToConstant: 28)
            ])
            memberStackView.addArrangedSubview(circleButton)
        }
        addMemberButton.layer.cornerRadius = 28 / 2
        NSLayoutConstraint.activate([
            addMemberButton.heightAnchor.constraint(equalToConstant: 28),
            addMemberButton.widthAnchor.constraint(equalToConstant: 28)
        ])
        memberStackView.addArrangedSubview(addMemberButton)
    }
    
    private func getYearMonth(from birthday: Date) -> (year: Int?, month: Int?) { // 當下載了Pet以後，Pet.birthday用這個取得目前的年月，供畫面顯示
        let calendar = Calendar.current
        let today = Date()
        let components = calendar.dateComponents([.year, .month], from: birthday, to: today)
        return (components.year, components.month)
    }
}
