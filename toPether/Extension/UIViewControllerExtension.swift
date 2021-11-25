//
//  UIViewControllerExtension.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/18.
//

import UIKit

extension UIViewController {
    
    func setNavigationBarColor(bgColor: UIColor, textColor: UIColor, tintColor: UIColor, titleTextSize size: CGFloat = 22) {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = bgColor
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: size) as Any, NSAttributedString.Key.foregroundColor: textColor]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        appearance.shadowColor = .clear
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func presentErrorAlert(title: String?, message: String?, completion: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            guard let completion = completion else { return }
            completion()
        }

        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func presentBlockAlert(title: String?, message: String?, completion: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let blockAction = UIAlertAction(title: "Block", style: .destructive) { _ in
            guard let completion = completion else { return }
            completion()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(blockAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
