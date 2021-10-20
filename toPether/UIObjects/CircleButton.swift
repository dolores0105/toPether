//
//  CircleButton.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/19.
//

import UIKit

class CircleButton: UIButton {

    convenience init(name: String?) {
        self.init()
        setTitle(name, for: .normal)
        setTitleColor(.mainBlue, for: .normal)
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.deepBlueGrey.cgColor
        layer.cornerRadius = 28 / 2
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 28),
            widthAnchor.constraint(equalToConstant: 28)
        ])
    }
}
