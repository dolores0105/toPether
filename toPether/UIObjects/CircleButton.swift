//
//  CircleButton.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/19.
//

import UIKit

class CircleButton: UIButton {

    convenience init(name: String = "") {
        self.init()
        setTitle(name, for: .normal)
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.deepBlueGrey.cgColor
        layer.cornerRadius = frame.height / 2
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 20),
            widthAnchor.constraint(equalToConstant: 20)
        ])
    }
}
