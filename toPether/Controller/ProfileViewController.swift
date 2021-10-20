//
//  ProfileViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/20.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var navigationBackgroundView: NavigationBackgroundView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Navigation controller
        self.navigationItem.title = "Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: 24), NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationBackgroundView = NavigationBackgroundView()
        view.addSubview(navigationBackgroundView)
        NSLayoutConstraint.activate([
            navigationBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBackgroundView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
}
