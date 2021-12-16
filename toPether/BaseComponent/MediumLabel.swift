//
//  MediumLabel.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/20.
//

import UIKit

class MediumLabel: UILabel {

    convenience init(size: CGFloat, text: String?, textColor: UIColor) {
        self.init()
        
        font = UIFont.medium(size: size)
        self.text = text
        self.textColor = textColor
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
