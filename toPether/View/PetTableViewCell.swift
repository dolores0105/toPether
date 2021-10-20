//
//  PetTableViewCell.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/20.
//

import UIKit

class PetTableViewCell: UITableViewCell {
    
    private var borderButton: BorderButton!
    private var petImageView: UIImageView!
    private var nameLabel: MediumLabel!
    private var genderImageView: UIImageView!
    private var ageLabel: UILabel!
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
