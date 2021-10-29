//
//  ArrayExtension.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/22.
//

import UIKit

extension Array where Element: BaseObject { // make array sorted by ids
    func sorted(by ids: [String]) -> [Element] {
        var items = [Element]()
        for id in ids {
            if let item = first(where: { $0.id == id }) {
                items.append(item)
            }
        }
        return items
    }
}
