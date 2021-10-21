//
//  RegularLabel.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/21.
//

import UIKit

class RegularLabel: UILabel {

    convenience init(size: CGFloat) {
        self.init()
        
        font = UIFont.regular(size: size)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
