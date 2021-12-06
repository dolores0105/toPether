//
//  ShadowView.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/10.
//

import UIKit

class ShadowView: UIView {
    
    convenience init(cornerRadius: CGFloat, color: UIColor, offset: CGSize, opacity: Float, radius: CGFloat) {
        self.init()
        backgroundColor = .white
        layer.cornerRadius = cornerRadius
        setShadow(color: color, offset: offset, opacity: opacity, radius: radius)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
