//
//  TabBarViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/3.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // HomePage
        let homeViewController = HomeViewController()
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        homeNavigationController.tabBarItem = UITabBarItem(title: "Home", image: Img.iconsHomeNormal.obj, selectedImage: Img.iconsHomeSelected.obj)
        
        // ToDoPage
        let toDoViewController = ToDoViewController()
        let toDoNavigationController = UINavigationController(rootViewController: toDoViewController)
        toDoNavigationController.tabBarItem = UITabBarItem(title: "To-Do", image: Img.iconsTodoNormal.obj, selectedImage: Img.iconsTodoSelected.obj)
        
        // ProfilePage
        let profileViewController = ProfileViewController()
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        profileNavigationController.tabBarItem = UITabBarItem(title: "Profile", image: Img.iconsProfileNormal.obj, selectedImage: Img.iconsProfileSelected.obj)

        self.setViewControllers([homeNavigationController, toDoNavigationController, profileNavigationController], animated: false)
        self.tabBar.tintColor = .mainBlue
        self.tabBar.unselectedItemTintColor = .deepBlueGrey
    }
}
