//
//  IconLabelHorizontalStackView.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/12.
//

import UIKit

class IconLabelHorizontalStackView: UIStackView {
    
    convenience init(icons: [UIImage], labelTexts: [String?]?, textColors: [UIColor], verticalSpacing: CGFloat, horizontalSpacing: CGFloat) {
        self.init()
        
        axis = .horizontal
        alignment = .center
        distribution = .equalSpacing
        spacing = horizontalSpacing
        translatesAutoresizingMaskIntoConstraints = false
        
        let firstVerticalStackView = IconLabelVerticalStackView(icon: icons[0], labelText: labelTexts?[0] ?? "", textColor: textColors[0], spacing: verticalSpacing)
        let secondVerticalStackView = IconLabelVerticalStackView(icon: icons[1], labelText: labelTexts?[1] ?? "", textColor: textColors[1], spacing: verticalSpacing)
        let thirdVerticalStackView = IconLabelVerticalStackView(icon: icons[2], labelText: labelTexts?[2] ?? "", textColor: textColors[2], spacing: verticalSpacing)
        
        addArrangedSubview(firstVerticalStackView)
        addArrangedSubview(secondVerticalStackView)
        addArrangedSubview(thirdVerticalStackView)
    }
}
