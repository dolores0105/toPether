//
//  RegularLabel.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/21.
//

import UIKit

class RegularLabel: UILabel {

    convenience init(size: CGFloat, text: String?, textColor: UIColor) {
        self.init()
        
        font = UIFont.regular(size: size)
        self.text = text
        self.textColor = textColor
        translatesAutoresizingMaskIntoConstraints = false
        
//        NSLayoutConstraint.activate([
//            heightAnchor.constraint(equalToConstant: 20)
//        ])
    }
}
