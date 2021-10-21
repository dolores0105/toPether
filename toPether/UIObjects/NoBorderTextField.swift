//
//  WhiteBorderTextField.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/20.
//

import UIKit
import IQKeyboardManagerSwift

class NoBorderTextField: UITextField {

    convenience init(name: String?) {
        self.init()
        backgroundColor = .clear
        layer.borderWidth = 0
        textColor = .white
        addDoneOnKeyboardWithTarget(self, action: #selector(dismissKeyboard))
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func dismissKeyboard(sender: UITextField) {
        endEditing(true)
    }
}
