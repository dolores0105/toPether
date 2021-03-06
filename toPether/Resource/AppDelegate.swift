//
//  AppDelegate.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/18.
//

import UIKit
import Firebase
import FirebaseAuth
import IQKeyboardManagerSwift
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        
        let userDefaults = UserDefaults.standard
        
        if !userDefaults.bool(forKey: "Installberfore") {
            print("First time install, setting userdefault")
            
            do {
                try Auth.auth().signOut()
            } catch {
                print("Fail to sign out previous user.")
            }
            
            userDefaults.set(true, forKey: "Installberfore")
            userDefaults.synchronize() // force the app to update userdefaults
        } else {
            print("User installed before, loading userDefaults")
        }

        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
        let todoViewController = ToDoViewController()
        let tabBarController = window?.rootViewController as? TabBarViewController

        tabBarController?.selectedIndex = 1
        let navigationController = tabBarController?.viewControllers?.first as? UINavigationController
        navigationController?.pushViewController(todoViewController, animated: true)
        UIApplication.shared.applicationIconBadgeNumber -= 1
        
        completionHandler()
    }
}
