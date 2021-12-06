//
//  SettingButton.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/10.
//

import UIKit

class SettingButton: BorderButton {

    convenience init(_ target: AnyObject, action: Selector, text: String, textfromCenterY: CGFloat, img: Img, imgSize: CGFloat) {
        self.init()
        addTarget(target, action: action, for: .touchUpInside)
        
        imageView?.contentMode = .scaleAspectFill
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        let label = MediumLabel(size: 20, text: text, textColor: .mainBlue)
        addSubview(label)
        
        let imageView = UIImageView(image: img.obj)
        imageView.alpha = 0.1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: textfromCenterY),
            label.heightAnchor.constraint(equalToConstant: 24),
            
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 14),
            imageView.widthAnchor.constraint(equalToConstant: imgSize + 24),
            imageView.heightAnchor.constraint(equalToConstant: imgSize + 24)
        ])
        
    }
}
