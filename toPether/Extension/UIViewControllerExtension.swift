//
//  UIViewControllerExtension.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/18.
//

import UIKit

extension UIViewController {
    
    func presentErrorAlert(title: String?, message: String?, completion: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            guard let completion = completion else { return }
            completion()
        }

        alert.addAction(okAction)
        
        present(alert, animated: true, completion: completion)
    }
}
