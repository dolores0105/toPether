//
//  IconButton.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/19.
// swiftlint: disable identifier_name

import UIKit

class IconButton: BorderButton {

    convenience init(_ target: AnyObject, action: Selector, img: Img) {
        self.init()
        imageView?.contentMode = .scaleAspectFill
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        setImage(img.obj, for: .normal)
        addTarget(target, action: action, for: .touchUpInside)
    }
}
