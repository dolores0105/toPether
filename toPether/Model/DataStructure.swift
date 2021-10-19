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

struct Pet: Codable {
    var petId: String
    var petName: String
    var petGender: String
    var birthday: Date
    var photo: String
    var groupMembersId: [String]
    
    var photoImage: UIImage {
        UIImage(data: Data(base64Encoded: photo) ?? .init()) ?? .init()
    }
}

struct Member: Codable {
    var memberId: String
    var memberName: String
    var petsId: [String]
    var qrCode: String
}
