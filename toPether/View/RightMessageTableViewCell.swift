//
//  RightMessageTableViewCell.swift
//  toPether
//
//  Created by user on 2021/11/7.
//

import UIKit

class RightMessageTableViewCell: MessageTableViewCell {

    override func initConstraints() {
        senderNameLabel.isHidden = true
        
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: contentLabelView.topAnchor, constant: 8),
            contentLabel.bottomAnchor.constraint(equalTo: contentLabelView.bottomAnchor, constant: -8),
            contentLabel.leadingAnchor.constraint(equalTo: contentLabelView.leadingAnchor, constant: 8),
            contentLabel.trailingAnchor.constraint(equalTo: contentLabelView.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            contentLabelView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            contentLabelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            contentLabelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])

        sentTimeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        NSLayoutConstraint.activate([
            sentTimeLabel.bottomAnchor.constraint(equalTo: contentLabelView.bottomAnchor),
            sentTimeLabel.trailingAnchor.constraint(equalTo: contentLabelView.leadingAnchor, constant: -12),
            sentTimeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 24)
        ])
        
        contentLabelView.layer.borderColor = UIColor.mainYellow.cgColor
        contentLabelView.setShadow(color: .mainYellow, offset: CGSize(width: 3.0, height: 3.0), opacity: 0.15, radius: 5)
    }

}
