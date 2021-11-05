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
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        } else {
            imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        }
        
        setImage(img.obj, for: .normal)
        addTarget(target, action: action, for: .touchUpInside)
    }
}
