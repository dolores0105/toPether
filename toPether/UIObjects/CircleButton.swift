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
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    convenience init(img: UIImage?, bgColor: UIColor, borderColor: UIColor) {
        self.init()
        setImage(img, for: .normal)
        imageView?.contentMode = .scaleAspectFill
        clipsToBounds = true
        backgroundColor = bgColor
        layer.borderWidth = 1
        layer.borderColor = borderColor.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        
        imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    }
}
