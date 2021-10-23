//
//  BlueBorderTextField.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/22.
//

import UIKit

class BlueBorderTextField: UITextField {

    convenience init(text: String?) {
        self.init()
        backgroundColor = .clear
        layer.borderWidth = 1
        layer.borderColor = UIColor.mainBlue.cgColor
        layer.cornerRadius = 10
        textColor = .mainBlue
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
