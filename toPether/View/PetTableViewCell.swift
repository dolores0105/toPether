//
//  PetTableViewCell.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/20.
//

import UIKit

class PetTableViewCell: UITableViewCell {
    
    private var borderButton: BorderButton!
    private var petImageView: RoundCornerImageView!
    private var nameLabel: MediumLabel!
    private var genderImageView: RoundCornerImageView!
    private var ageLabel: RegularLabel!
    private var memberNumberButton: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        borderButton = BorderButton()
        contentView.addSubview(borderButton)
        NSLayoutConstraint.activate([
            borderButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            borderButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            borderButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            borderButton.heightAnchor.constraint(equalToConstant: 64),
            borderButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        petImageView = RoundCornerImageView(img: nil)
        petImageView.backgroundColor = .gray //mock
        contentView.addSubview(petImageView)
        NSLayoutConstraint.activate([
            petImageView.bottomAnchor.constraint(equalTo: borderButton.bottomAnchor, constant: -12),
            petImageView.topAnchor.constraint(equalTo: borderButton.topAnchor, constant: 12),
            petImageView.leadingAnchor.constraint(equalTo: borderButton.leadingAnchor, constant: 12),
            petImageView.widthAnchor.constraint(equalTo: petImageView.heightAnchor)
        ])
        
        nameLabel = MediumLabel(size: 18)
        nameLabel.text = "Pet mock name" // mock
        nameLabel.textColor = .mainBlue
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: petImageView.topAnchor, constant: -6),
            nameLabel.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: borderButton.trailingAnchor, constant: -16)
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
        ageLabel.text = "0y 6m mock" // mock
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
        memberNumberButton.setTitle("+12", for: .normal) // mock
        memberNumberButton.setTitleColor(.deepBlueGrey, for: .normal)
        memberNumberButton.backgroundColor = .lightBlueGrey
        memberNumberButton.layer.cornerRadius = 10
        contentView.addSubview(memberNumberButton)
        NSLayoutConstraint.activate([
            memberNumberButton.centerYAnchor.constraint(equalTo: genderImageView.centerYAnchor),
            memberNumberButton.trailingAnchor.constraint(equalTo: borderButton.trailingAnchor, constant: -16),
            memberNumberButton.widthAnchor.constraint(equalToConstant: 50),
            memberNumberButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
