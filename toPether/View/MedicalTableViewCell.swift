//
//  MedicalTableViewCell.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/27.
// swiftlint:disable line_length

import UIKit

class MedicalTableViewCell: UITableViewCell {
    
    private var dotView: UIView!
    private var lineView: UIView!
    private var borderView: BorderView!
    private var symptomLabel: MediumLabel!
    private var dateLabel: MediumLabel!
    private var locateImageView: RoundCornerImageView!
    private var clinicLabel: RegularLabel!
    private var vetOrderLabel: RegularLabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        dotView = UIView()
        dotView.backgroundColor = .white
        dotView.layer.borderWidth = 4
        dotView.layer.borderColor = UIColor.mainYellow.cgColor
        dotView.layer.cornerRadius = 10
        contentView.addSubview(dotView)
        dotView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dotView.topAnchor.constraint(equalTo: contentView.topAnchor),
            dotView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            dotView.heightAnchor.constraint(equalToConstant: 20),
            dotView.widthAnchor.constraint(equalTo: dotView.heightAnchor)
        ])
        
        lineView = UIView()
        lineView.backgroundColor = .lightBlueGrey
        contentView.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineView.centerXAnchor.constraint(equalTo: dotView.centerXAnchor),
            lineView.widthAnchor.constraint(equalToConstant: 2),
            lineView.topAnchor.constraint(equalTo: dotView.centerYAnchor),
            lineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        contentView.bringSubviewToFront(dotView)
        
        dateLabel = MediumLabel(size: 16, text: nil, textColor: .deepBlueGrey)
        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: dotView.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: dotView.trailingAnchor, constant: 12),
            dateLabel.widthAnchor.constraint(equalToConstant: 160)
        ])
        
        borderView = BorderView()
        contentView.addSubview(borderView)
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12),
            borderView.leadingAnchor.constraint(equalTo: dotView.trailingAnchor, constant: 12),
            borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
        
        symptomLabel = MediumLabel(size: 18, text: nil, textColor: .mainBlue)
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
            locateImageView.topAnchor.constraint(equalTo: symptomLabel.bottomAnchor, constant: 8),
            locateImageView.leadingAnchor.constraint(equalTo: symptomLabel.leadingAnchor),
            locateImageView.heightAnchor.constraint(equalToConstant: 18),
            locateImageView.widthAnchor.constraint(equalTo: locateImageView.heightAnchor)
        ])
        
        clinicLabel = RegularLabel(size: 14, text: nil, textColor: .deepBlueGrey)
        contentView.addSubview(clinicLabel)
        NSLayoutConstraint.activate([
            clinicLabel.centerYAnchor.constraint(equalTo: locateImageView.centerYAnchor),
            clinicLabel.leadingAnchor.constraint(equalTo: locateImageView.trailingAnchor, constant: 12),
            clinicLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -12)
        ])
        
        vetOrderLabel = RegularLabel(size: 17, text: nil, textColor: .deepBlueGrey)
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
        symptomLabel.text = medical.symptoms
        clinicLabel.text = medical.clinic
        vetOrderLabel.text = medical.vetOrder
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d YYYY"
        dateFormatter.timeZone = TimeZone.current
        dateLabel.text = dateFormatter.string(from: medical.dateOfVisit)
    }
    
}
