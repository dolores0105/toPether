//
//  UIFontExtension.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/18.
//

import UIKit

private enum STFontName: String {

    case regular = "NotoSansChakma-Regular"
    case medium = "NotoSansChakma-Medium"
    case semiBold = "NotoSansChakma-SemiBold"
}

extension UIFont {

    static func medium(size: CGFloat) -> UIFont? {

        var descriptor = UIFontDescriptor(name: STFontName.medium.rawValue, size: size)

        descriptor = descriptor.addingAttributes(
            [UIFontDescriptor.AttributeName.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.medium]]
        )

        let font = UIFont(descriptor: descriptor, size: size)

        return font
    }

    static func regular(size: CGFloat) -> UIFont? {

        return STFont(.regular, size: size)
    }

//    static func medium(size: CGFloat) -> UIFont? {
//
//        return STFont(.medium, size: size)
//    }

    static func semiBold(size: CGFloat) -> UIFont? {

        return STFont(.semiBold, size: size)
    }
    
    private static func STFont(_ font: STFontName, size: CGFloat) -> UIFont? {

        return UIFont(name: font.rawValue, size: size)
    }
}
