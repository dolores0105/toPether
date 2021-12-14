//
//  BorderButton.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/19.
//

import UIKit

class BorderButton: UIButton {

    override required init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.mainBlue.cgColor
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
