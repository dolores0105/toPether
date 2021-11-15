//
//  Alert.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/11.
//

import UIKit

struct Alert {
    
    static func deleteAlert(title: String, message: String?, deleteCompletion: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            guard let deleteCompletion = deleteCompletion else { return }
            deleteCompletion()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        return alert
    }
}
