//
//  CardView.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/5.
//

import UIKit

class CardView: UIView {

    convenience init(color: UIColor, cornerRadius: CGFloat) {
        self.init()
        
        backgroundColor = color
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = cornerRadius
        
        translatesAutoresizingMaskIntoConstraints = false
    }
}
