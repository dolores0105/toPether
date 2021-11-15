//
//  DictionaryExtension.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/9.
//

import Foundation
import UIKit

extension Dictionary where Value: Equatable {
    func someKey(forValue value: Value) -> Key? {
        return first(where: { $1 == value })?.key
    }
}
