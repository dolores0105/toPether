//
//  SplashVC.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/22.
//

import UIKit

class SplashVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // mock member as current user
        UserDefaults.standard.set("XlppR0WMxxoHuUQboJMs", forKey: "userId")
        
        guard let id = UserDefaults.standard.string(forKey: "userId") else {
            // Goto Register
            return
        }
        
        // ㄎㄞ ㄉㄨˊㄑㄩˇㄉㄨㄥˋㄏㄨㄚˋ
        
        MemberModel.shared.queryCurrentUser(id: id) { [weak self] result in
            switch result {
            case .success(let member):
                MemberModel.shared.current = member
                // Goto Home
                self?.gotoTabbarVC()
            case .failure(let error):
                // Response the error to USER
                break
            }
            // ㄍㄨㄢ ㄉㄨˊㄑㄩˇㄉㄨㄥˋㄏㄨㄚˋ
        }
    }
    
    private func gotoTabbarVC() {
        //HomePage
        let homeViewController = HomeViewController()
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        homeNavigationController.tabBarItem = UITabBarItem(title: nil, image: Img.iconsHomeNormal.obj, selectedImage: Img.iconsHomeSelected.obj)
        
        //ProfilePage
        let profileViewController = ProfileViewController()
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        profileNavigationController.tabBarItem = UITabBarItem(title: nil, image: Img.iconsProfileNormal.obj, selectedImage: Img.iconsProfileSelected.obj)
        
        let tabBarViewController = UITabBarController()
        tabBarViewController.setViewControllers([homeNavigationController, profileNavigationController], animated: false)
        
        UIApplication.shared.keyWindow?.rootViewController = tabBarViewController
    }
}
