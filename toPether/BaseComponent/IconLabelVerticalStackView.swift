//
//  IconLabelVerticalStackView.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/12.
//

import UIKit

class IconLabelVerticalStackView: UIStackView {
    
    convenience init(icon: UIImage, labelText: String, textColor: UIColor, spacing: CGFloat) {
        self.init()
        
        let iconImageView = RoundCornerImageView(image: icon)
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 18),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor)
        ])
        
        let textLabel = RegularLabel(size: 16, text: labelText, textColor: textColor)
        textLabel.textAlignment = .center
        NSLayoutConstraint.activate([
            textLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        axis = .vertical
        alignment = .center
        distribution = .equalSpacing
        self.spacing = spacing
        translatesAutoresizingMaskIntoConstraints = false
        
        addArrangedSubview(iconImageView)
        addArrangedSubview(textLabel)
    }
}
