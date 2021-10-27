//
//  MedicalTableViewCell.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/27.
// swiftlint:disable line_length

import UIKit

class MedicalTableViewCell: UITableViewCell {
    
    private var borderView: BorderView!
    private var symptomLabel: MediumLabel!
    private var locateImageView: RoundCornerImageView!
    private var clinicLabel: RegularLabel!
    private var vetOrderLabel: RegularLabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        borderView = BorderView()
        contentView.addSubview(borderView)
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        
        symptomLabel = MediumLabel(size: 18,
                                   text: "Mock symptoms Mock symptoms Mock symptoms Mock symptoms Mock symptoms Mock symptoms",
                                   textColor: .mainBlue)
        symptomLabel.numberOfLines = 0
        contentView.addSubview(symptomLabel)
        NSLayoutConstraint.activate([
            symptomLabel.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 12),
            symptomLabel.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 12),
            symptomLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -12)
        ])
        
        locateImageView = RoundCornerImageView(img: Img.iconsLocate.obj)
        contentView.addSubview(locateImageView)
        NSLayoutConstraint.activate([
            locateImageView.topAnchor.constraint(equalTo: symptomLabel.bottomAnchor, constant: 12),
            locateImageView.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 12),
            locateImageView.heightAnchor.constraint(equalToConstant: 20),
            locateImageView.widthAnchor.constraint(equalTo: locateImageView.heightAnchor)
        ])
        
        clinicLabel = RegularLabel(size: 14, text: "mock clinic", textColor: .deepBlueGrey)
        contentView.addSubview(clinicLabel)
        NSLayoutConstraint.activate([
            clinicLabel.centerYAnchor.constraint(equalTo: locateImageView.centerYAnchor),
            clinicLabel.leadingAnchor.constraint(equalTo: locateImageView.trailingAnchor, constant: 12),
            clinicLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -12)
        ])
        
        vetOrderLabel = RegularLabel(size: 17,
                                     text: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum",
                                     textColor: .deepBlueGrey)
        vetOrderLabel.numberOfLines = 0
        contentView.addSubview(vetOrderLabel)
        NSLayoutConstraint.activate([
            vetOrderLabel.topAnchor.constraint(equalTo: locateImageView.bottomAnchor, constant: 16),
            vetOrderLabel.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 12),
            vetOrderLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -12),
            vetOrderLabel.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: functions
    func reload(medical: Medical) {
        updateCell(medical: medical)
        addListener()
    }
    
    func updateCell(medical: Medical) {
        symptomLabel.text = medical.symptoms
        clinicLabel.text = medical.clinic
        vetOrderLabel.text = medical.vetOrder
    }
    
    func addListener() {
        // updateCell(medical: <#T##Medical#>)
    }
}
