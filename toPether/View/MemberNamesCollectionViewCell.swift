//
//  MemberNamesCollectionViewCell.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/18.
//

import UIKit

class MemberNamesCollectionViewCell: UICollectionViewCell {
    var circleView: UIView!
    var memberNameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        circleView = UIImageView()
        circleView.layer.borderWidth = 1
        circleView.layer.borderColor = UIColor.lightBlueGrey.cgColor
        circleView.layer.cornerRadius = frame.height / 2
        circleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(circleView)
        
        NSLayoutConstraint.activate([
            
            circleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            circleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            circleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            circleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
