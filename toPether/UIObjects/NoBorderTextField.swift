//
//  WhiteBorderTextField.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/20.
//

import UIKit
import IQKeyboardManagerSwift

class NoBorderTextField: UITextField {

    convenience init(bgColor: UIColor, textColor: UIColor) {
        self.init()
        backgroundColor = bgColor
        layer.borderWidth = 0
        self.textColor = textColor
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
