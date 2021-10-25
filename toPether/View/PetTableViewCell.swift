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
    
    private var borderView: UIView!
    private var petImageView: RoundCornerImageView!
    private var nameLabel: MediumLabel!
    private var genderImageView: RoundCornerImageView!
    private var ageLabel: RegularLabel!
    private var memberNumberButton: UIButton!
    
    private var listener: ListenerRegistration?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        borderView = UIView()
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.mainBlue.cgColor
        borderView.layer.cornerRadius = 10
        borderView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(borderView)
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            borderView.heightAnchor.constraint(equalToConstant: 64),
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
        
        nameLabel = MediumLabel(size: 18)
        nameLabel.textColor = .mainBlue
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: petImageView.topAnchor, constant: -6),
            nameLabel.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -16)
        ])
        
        genderImageView = RoundCornerImageView(img: Img.iconsGenderFemale.obj)
        contentView.addSubview(genderImageView)
        NSLayoutConstraint.activate([
            genderImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            genderImageView.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 16),
            genderImageView.heightAnchor.constraint(equalToConstant: 16),
            genderImageView.widthAnchor.constraint(equalTo: genderImageView.heightAnchor)
        ])
        
        ageLabel = RegularLabel(size: 14)
        ageLabel.textColor = .deepBlueGrey
        contentView.addSubview(ageLabel)
        NSLayoutConstraint.activate([
            ageLabel.centerYAnchor.constraint(equalTo: genderImageView.centerYAnchor),
            ageLabel.leadingAnchor.constraint(equalTo: genderImageView.trailingAnchor, constant: 8),
            ageLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        memberNumberButton = UIButton()
        memberNumberButton.translatesAutoresizingMaskIntoConstraints = false
        memberNumberButton.titleLabel?.font = UIFont.regular(size: 14)
        memberNumberButton.setTitleColor(.deepBlueGrey, for: .normal)
        memberNumberButton.backgroundColor = .lightBlueGrey
        memberNumberButton.layer.cornerRadius = 10
        contentView.addSubview(memberNumberButton)
        NSLayoutConstraint.activate([
            memberNumberButton.centerYAnchor.constraint(equalTo: genderImageView.centerYAnchor),
            memberNumberButton.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -16),
            memberNumberButton.widthAnchor.constraint(equalToConstant: 50),
            memberNumberButton.heightAnchor.constraint(equalToConstant: 20)
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
        
        var year: Int?
        var month: Int?
        (year, month) = getYearMonth(from: pet.birthday)
        guard let year = year, let month = month else { return }
        ageLabel.text = "\(year)y  \(month)m"
        
        if pet.gender == "male" {
            genderImageView.image = Img.iconsGenderMale.obj
        } else {
            genderImageView.image = Img.iconsGenderFemale.obj
        }
        
        memberNumberButton.setTitle("+ \(pet.memberIds.count)", for: .normal)
    }
    
    func addListener(pet: Pet) {
            listener?.remove() // remove instance listener, Stop listening to changes
        // add pet listener
            listener = PetModel.shared.addPetListener(pet: pet, completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let pet):
                    self.updateCell(pet: pet)

                case .failure(let error):
                    print("addListener error", error)
                }
                
            })
    }
    
    private func getYearMonth(from birthday: Date) -> (year: Int?, month: Int?) { // 當下載了Pet以後，Pet.birthday用這個取得目前的年月，供畫面顯示
        let calendar = Calendar.current
        let today = Date()
        let components = calendar.dateComponents([.year, .month], from: birthday, to: today)
        return (components.year, components.month)
    }
}
