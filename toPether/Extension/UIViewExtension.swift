//
//  UIViewExtension.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/3.
//

import UIKit

extension UIView {
    
    func setShadow(color: UIColor, offset: CGSize, opacity: Float, radius: CGFloat) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    func float(duration: Double) {
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [.autoreverse, .repeat],
            animations: {
                self.frame = CGRect(
                    x: self.frame.origin.x,
                    y: self.frame.origin.y - 10,
                    width: self.frame.size.width,
                    height: self.frame.size.height)
            },
            completion: nil
        )
    }
}
