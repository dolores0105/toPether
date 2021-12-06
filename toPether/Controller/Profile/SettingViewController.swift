//
//  SettingViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/10.
//

import UIKit
import FirebaseAuth

class SettingViewController: UIViewController {

    private var privacyButton: SettingButton!
    private var deleteAccountButton: SettingButton!
    private var signOutButton: SettingButton!
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configPrivacyButton()
        configDeleteAccountButton()
        configSignOutButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.navigationItem.title = "Settings"
        self.setNavigationBarColor(bgColor: .white, textColor: .mainBlue, tintColor: .mainBlue)

        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - @objc Functions
    
    @objc private func tapPrivacy(_ sender: SettingButton) {
        let privacyPolicyViewController = WebViewController(urlString: "https://www.privacypolicies.com/live/ee7f5a2b-33d3-4b00-bf9b-32d784f8cb81")
        navigationController?.pushViewController(privacyPolicyViewController, animated: true)
    }
    
    @objc private func tapDeleteAccount(_ sender: SettingButton) {
        let alertController = UIAlertController(title: "Delete account",
                                                message: "It's means all your datas would be cleaned. If you wish to do it, please contact yihsuanlin.dolores@gmail.com",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Back", style: .default, handler: nil)
        
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func tapSignOut(_ sender: SettingButton) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            let signInViewController = SplashViewController()
            navigationController?.pushViewController(signInViewController, animated: true)
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            self.presentErrorAlert(message: signOutError.localizedDescription + " Please try again")
        }
    }
}

// MARK: - UI Configure Functions

extension SettingViewController {
    
    private func configPrivacyButton() {
        privacyButton = SettingButton(self, action: #selector(tapPrivacy), text: "Privacy policy", textfromCenterY: 0, img: Img.iconsPrivacy, imgSize: 88)
        let shadow = ShadowView(cornerRadius: 10, color: .mainBlue, offset: CGSize(width: 1.0, height: 3.0), opacity: 0.2, radius: 10)
        
        view.addSubview(shadow)
        view.addSubview(privacyButton)
        NSLayoutConstraint.activate([
            privacyButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            privacyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            privacyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            privacyButton.heightAnchor.constraint(equalToConstant: 88),
            
            shadow.topAnchor.constraint(equalTo: privacyButton.topAnchor),
            shadow.bottomAnchor.constraint(equalTo: privacyButton.bottomAnchor),
            shadow.leadingAnchor.constraint(equalTo: privacyButton.leadingAnchor),
            shadow.trailingAnchor.constraint(equalTo: privacyButton.trailingAnchor)
        ])
    }
    
    private func configDeleteAccountButton() {
        deleteAccountButton = SettingButton(self, action: #selector(tapDeleteAccount), text: "Delete account", textfromCenterY: 0, img: Img.iconsCry, imgSize: 88)
        let shadow = ShadowView(cornerRadius: 10, color: .mainBlue, offset: CGSize(width: 1.0, height: 3.0), opacity: 0.2, radius: 10)
        
        view.addSubview(shadow)
        view.addSubview(deleteAccountButton)
        NSLayoutConstraint.activate([
            deleteAccountButton.topAnchor.constraint(equalTo: privacyButton.bottomAnchor, constant: 24),
            deleteAccountButton.leadingAnchor.constraint(equalTo: privacyButton.leadingAnchor),
            deleteAccountButton.trailingAnchor.constraint(equalTo: privacyButton.trailingAnchor),
            deleteAccountButton.heightAnchor.constraint(equalToConstant: 88),
            
            shadow.topAnchor.constraint(equalTo: deleteAccountButton.topAnchor),
            shadow.bottomAnchor.constraint(equalTo: deleteAccountButton.bottomAnchor),
            shadow.leadingAnchor.constraint(equalTo: deleteAccountButton.leadingAnchor),
            shadow.trailingAnchor.constraint(equalTo: deleteAccountButton.trailingAnchor)
        ])
    }
    
    private func configSignOutButton() {
        signOutButton = SettingButton(self, action: #selector(tapSignOut), text: "Sign out", textfromCenterY: 0, img: Img.iconsSignOut, imgSize: 88)
        let shadow = ShadowView(cornerRadius: 10, color: .mainBlue, offset: CGSize(width: 1.0, height: 3.0), opacity: 0.2, radius: 10)
        
        view.addSubview(shadow)
        view.addSubview(signOutButton)
        NSLayoutConstraint.activate([
            signOutButton.topAnchor.constraint(equalTo: deleteAccountButton.bottomAnchor, constant: 24),
            signOutButton.leadingAnchor.constraint(equalTo: deleteAccountButton.leadingAnchor),
            signOutButton.trailingAnchor.constraint(equalTo: deleteAccountButton.trailingAnchor),
            signOutButton.heightAnchor.constraint(equalToConstant: 88),
            
            shadow.topAnchor.constraint(equalTo: signOutButton.topAnchor),
            shadow.bottomAnchor.constraint(equalTo: signOutButton.bottomAnchor),
            shadow.leadingAnchor.constraint(equalTo: signOutButton.leadingAnchor),
            shadow.trailingAnchor.constraint(equalTo: signOutButton.trailingAnchor)
        ])
    }
}
