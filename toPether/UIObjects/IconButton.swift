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

        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        } else {
            imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        }
        
        setImage(img.obj, for: .normal)
        addTarget(target, action: action, for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 64),
            widthAnchor.constraint(equalToConstant: 64)
        ])
    }
}
