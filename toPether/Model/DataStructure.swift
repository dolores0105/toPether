//
//  DataStructure.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/19.
//

import FirebaseFirestore
import UIKit

protocol BaseObject {
    var id: String { get set }
}

class Pet: BaseObject, Codable {
    var id: String = ""
    var name: String = ""
    var gender: String = ""
    var birthday: Date = .init(timeIntervalSince1970: 0)
    var photo: String = ""
    var memberIds: [String] = []
    
    var photoImage: UIImage {
        UIImage(data: Data(base64Encoded: photo) ?? .init()) ?? .init()
    }
    
    var ageInfo: String? {
        guard case let (year?, month?) = PetModel.shared.getYearMonth(from: birthday) else { return nil }
        return String(year) + "y  " + String(month) + "m"
    }
}

class Member: BaseObject, Codable {
    var id: String = ""
    var name: String = ""
    var petIds: [String] = []
//    var qrCode: String = ""
}

class Medical: BaseObject, Codable {
    var id: String = ""
    var symptoms: String = ""
    var dateOfVisit: Date = .init(timeIntervalSince1970: 0)
    var clinic: String = ""
    var vetOrder: String = ""
}

class Food: BaseObject, Codable {
    var id: String = ""
    var name: String = ""
    var weight: String = ""
    var unit: String = ""
    var price: String = ""
    var market: String = ""
    var dateOfPurchase: Date = .init(timeIntervalSince1970: 0)
    var note: String = ""
}

class Message: BaseObject, Codable {
    var id: String = ""
    var senderId: String = ""
    var sentTime: Date = .init(timeIntervalSince1970: 0)
    var content: String = ""
}

class ToDo: BaseObject, Codable {
    var id: String = ""
    var creatorId: String = ""
    var executorId: String = ""
    var petId: String = ""
    var dueTime: Date = .init(timeIntervalSince1970: 0)
    var content: String = ""
    var doneStatus: Bool = false
}
