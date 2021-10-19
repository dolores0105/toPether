//
//  UIFont.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/18.
//

import UIKit

private enum STFontName: String {

    case regular = "NotoSansChakma-Regular"
}

extension UIFont {

    static func medium(size: CGFloat) -> UIFont? {

        var descriptor = UIFontDescriptor(name: STFontName.regular.rawValue, size: size)

        descriptor = descriptor.addingAttributes(
            [UIFontDescriptor.AttributeName.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.medium]]
        )

        let font = UIFont(descriptor: descriptor, size: size)

        return font
    }

    static func regular(size: CGFloat) -> UIFont? {

        return STFont(.regular, size: size)
    }

    private static func STFont(_ font: STFontName, size: CGFloat) -> UIFont? {

        return UIFont(name: font.rawValue, size: size)
    }
}
