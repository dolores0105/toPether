//
//  LineView.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/30.
//

import UIKit

class LineView: UIView {

    convenience init(color: UIColor, width: CGFloat) {
        self.init()
        backgroundColor = color
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width)
        ])
    }
}
