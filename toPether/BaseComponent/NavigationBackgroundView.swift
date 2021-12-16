//
//  NavigationBackgroundView.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/20.
//

import UIKit

class NavigationBackgroundView: UIView {

    override required init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainBlue
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
