//
//  RoundButton.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/22.
//

import UIKit

class RoundButton: UIButton {
    
    convenience init(text: String?) {
        self.init()
        setTitle(text, for: .normal)
        setTitleColor(.deepBlueGrey, for: .normal) // normal status
        backgroundColor = .lightBlueGrey // normal status
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
//    override var isSelected: Bool {
//        didSet {
//            backgroundColor = isSelected ? UIColor.mainBlue : UIColor.lightBlueGrey
//            isSelected ? setTitleColor(.lightBlueGrey, for: .normal) : setTitleColor(.deepBlueGrey, for: .normal)
//        }
//    }
}
