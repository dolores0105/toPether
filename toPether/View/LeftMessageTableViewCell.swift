//
//  LeftMessageTableViewCell.swift
//  toPether
//
//  Created by user on 2021/11/7.
//

import UIKit

class LeftMessageTableViewCell: MessageTableViewCell {

    override func initConstraints() {
        NSLayoutConstraint.activate([
            senderNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            senderNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            senderNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 2 / 3)
        ])
        
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: contentLabelView.topAnchor, constant: 8),
            contentLabel.bottomAnchor.constraint(equalTo: contentLabelView.bottomAnchor, constant: -8),
            contentLabel.leadingAnchor.constraint(equalTo: contentLabelView.leadingAnchor, constant: 8),
            contentLabel.trailingAnchor.constraint(equalTo: contentLabelView.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            contentLabelView.topAnchor.constraint(equalTo: senderNameLabel.bottomAnchor, constant: 12),
            contentLabelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            contentLabelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24)
        ])

        sentTimeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        NSLayoutConstraint.activate([
            sentTimeLabel.bottomAnchor.constraint(equalTo: contentLabelView.bottomAnchor),
            sentTimeLabel.leadingAnchor.constraint(equalTo: contentLabelView.trailingAnchor, constant: 12),
            sentTimeLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 24)
        ])
        
        contentLabelView.layer.borderColor = UIColor.mainBlue.cgColor
        contentLabelView.setShadow(color: .mainBlue, offset: CGSize(width: 3.0, height: 3.0), opacity: 0.1, radius: 5)
    }

}
