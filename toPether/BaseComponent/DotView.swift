//
//  DotView.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/30.
//

import UIKit

class DotView: UIView {

    convenience init(bordercolor: UIColor, size: CGFloat) {
        self.init()
        backgroundColor = .white
        layer.borderWidth = 4
        layer.borderColor = bordercolor.cgColor
        layer.cornerRadius = size / 2
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: size),
            widthAnchor.constraint(equalToConstant: size)
        ])
    }
}
