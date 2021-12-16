//
//  RoundCornerImageView.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/21.
//

import UIKit

class RoundCornerImageView: UIImageView {

    convenience init(img: UIImage?) {
        self.init()
        image = img
        clipsToBounds = true
        contentMode = .scaleAspectFill
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
    }
}
