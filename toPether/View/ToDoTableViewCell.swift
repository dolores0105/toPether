//
//  ToDoTableViewCell.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/8.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    private var borderView: BorderView!
    private var doneButton: CircleButton!
    private var todoLabel: MediumLabel!
//    private var iconsImageView: UIImageView!
    private var duetimeLabel: RegularLabel!
    private var executorLabel: MediumLabel!
    private var petLabel: MediumLabel!
    
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
            borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        doneButton = CircleButton(name: "")
        doneButton.layer.cornerRadius = 16
        contentView.addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 20),
            doneButton.centerYAnchor.constraint(equalTo: borderView.centerYAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 32),
            doneButton.widthAnchor.constraint(equalTo: doneButton.heightAnchor)
        ])
        
        todoLabel = MediumLabel(size: 18, text: "Mock todo take food package at 7-11", textColor: .mainBlue)
        todoLabel.numberOfLines = 0
        contentView.addSubview(todoLabel)
        NSLayoutConstraint.activate([
            todoLabel.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 16),
            todoLabel.leadingAnchor.constraint(equalTo: doneButton.trailingAnchor, constant: 20),
            todoLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -24)
        ])
        
//        iconsImageView = UIImageView(image: Img.iconsClock.obj)
//        iconsImageView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(iconsImageView)
//        NSLayoutConstraint.activate([
//
//        ])
        
        duetimeLabel = RegularLabel(size: 16, text: "14:30", textColor: .deepBlueGrey)
        contentView.addSubview(duetimeLabel)
        NSLayoutConstraint.activate([
            duetimeLabel.topAnchor.constraint(equalTo: todoLabel.bottomAnchor, constant: 4),
            duetimeLabel.heightAnchor.constraint(equalToConstant: 18),
            duetimeLabel.leadingAnchor.constraint(equalTo: todoLabel.leadingAnchor)
        ])
        
        executorLabel = MediumLabel(size: 16, text: "Mock ppl bbbbbbb", textColor: .mainBlue)
        contentView.addSubview(executorLabel)
        NSLayoutConstraint.activate([
            executorLabel.topAnchor.constraint(equalTo: duetimeLabel.bottomAnchor, constant: 4),
            executorLabel.leadingAnchor.constraint(equalTo: todoLabel.leadingAnchor),
            executorLabel.heightAnchor.constraint(equalToConstant: 18),
            executorLabel.widthAnchor.constraint(equalTo: borderView.widthAnchor, multiplier: 1 / 2, constant: -48)
        ])
        
        petLabel = MediumLabel(size: 16, text: "Ronaldo", textColor: .mainBlue)
        petLabel.textAlignment = .right
        contentView.addSubview(petLabel)
        NSLayoutConstraint.activate([
            petLabel.centerYAnchor.constraint(equalTo: executorLabel.centerYAnchor),
            petLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -24),
            petLabel.heightAnchor.constraint(equalToConstant: 18),
            petLabel.widthAnchor.constraint(equalTo: borderView.widthAnchor, multiplier: 1 / 2, constant: -64),
            petLabel.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -16)
        ])
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
