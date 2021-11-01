//
//  BorderSearchBar.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/30.
//

import UIKit

class BorderSearchBar: UISearchBar {

    convenience init(placeholder: String?) {
        self.init()
        backgroundImage = UIImage()
        self.placeholder = placeholder
        searchTextField.backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.mainBlue.cgColor
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

