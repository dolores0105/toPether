//
//  UIImageExtension.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/19.
//

import UIKit

enum Img: String {
    case iconsMessage
    case iconsFoodRecords
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
    case iconsAdd
    case iconsDelete
    case iconsAddWhite
    case iconsLocate
    case iconsClock
    
    var obj: UIImage {
        return UIImage(named: rawValue)!
    }
}
