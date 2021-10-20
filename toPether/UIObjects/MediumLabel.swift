//
//  MediumLabel.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/20.
//

import UIKit

class MediumLabel: UILabel {

    convenience init(size: CGFloat) {
        self.init()
        
        font = UIFont.medium(size: size)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
