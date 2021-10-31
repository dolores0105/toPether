//
//  FoodRecordViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/31.
//

import UIKit

class FoodRecordViewController: UIViewController {

    
    convenience init(selectedPetId: String, food: Food?) {
        self.init()
        self.selectedPetId = selectedPetId
        self.food = food
    }
    private var selectedPetId: String!
    private var food: Food?
    
    override func viewWillAppear(_ animated: Bool) {
        // MARK: Navigation controller
        self.navigationItem.title = "Food record"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: 24) as Any, NSAttributedString.Key.foregroundColor: UIColor.mainBlue]
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
    }
    
}
