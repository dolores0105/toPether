//
//  BlurView.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/26.
//

import UIKit

class BlurView: UIView {

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        backgroundColor = .blurBlue
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
