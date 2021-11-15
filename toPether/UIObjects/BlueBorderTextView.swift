//
//  BlueBorderTextView.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/14.
//

import UIKit

class BlueBorderTextView: UITextView {

    convenience init(_ delegate: UITextViewDelegate, textSize: CGFloat, height: CGFloat) {
        self.init()
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.borderColor = UIColor.mainBlue.cgColor
        layer.borderWidth = 1
        font = UIFont.regular(size: textSize)
        textColor = .mainBlue
        textContainer.lineFragmentPadding = 12
        self.delegate = delegate
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: height)
        ])
    }
}
