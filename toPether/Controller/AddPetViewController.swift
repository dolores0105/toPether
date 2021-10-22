//
//  AddPetViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/22.
//

import UIKit

class AddPetViewController: UIViewController {
    convenience init(currentUser: Member) {
        self.init()
        self.currentUser = currentUser
    }
    private var currentUser: Member!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Navigation controller
        self.navigationItem.title = "Furkid"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: 24) as Any, NSAttributedString.Key.foregroundColor: UIColor.mainBlue]
    }

}
