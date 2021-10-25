//
//  InviteViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/25.
//

import UIKit

class InviteViewController: UIViewController {
    
    convenience init(pet: Pet) {
        self.init()
        self.pet = pet
    }
    private var pet: Pet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(pet.name)
    }

}
