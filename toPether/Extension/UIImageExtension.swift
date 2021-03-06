//
//  UIImageExtension.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/19.
//

import UIKit

enum Img: String {
    case iconsMessage
    case iconsFood
    case iconsMedicalRecords
    case iconsGallery
    case iconsGenderFemale
    case iconsGenderMale
    case iconsHomeNormal
    case iconsHomeSelected
    case iconsProfileNormal
    case iconsProfileSelected
    case iconsQrcode
    case iconsEdit
    case iconsEditWhite
    case iconsAdd
    case iconsDelete
    case iconsAddWhite
    case iconsLocate
    case iconsTodoNormal
    case iconsTodoSelected
    case iconsSend
    case iconsApp
    case iconsCheck
    case iconsSetting
    case iconsPrivacy
    case iconsCry
    case iconsSignOut
    case appLogoNameWhite
    case appNameBlue
    case appNameWhite
    case toPetherIcon
    case iconsFace
    case iconsClock
    case iconsPerson
    case iconsPaw
    case iconsProfile
    case iconsPang
    case iconsBlock
    
    var obj: UIImage {
        return UIImage(named: rawValue)!
    }
}
