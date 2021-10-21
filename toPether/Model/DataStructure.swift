//
//  DataStructure.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/19.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import UIKit

class Pet: Codable {
    var id: String = ""
    var name: String = ""
    var gender: String = ""
    var birthday: Date = .init(timeIntervalSince1970: 0)
    var photo: String = ""
    var memberIds: [String] = []
    
    var photoImage: UIImage {
        UIImage(data: Data(base64Encoded: photo) ?? .init()) ?? .init()
    }
}

class Member: Codable {
    var id: String = ""
    var name: String = ""
    var petIds: [String] = []
    var qrCode: String = ""
}
