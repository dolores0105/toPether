//
//  SettingViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/10.
//

import UIKit

class SettingViewController: UIViewController {

    private var nameButton: SettingButton!
    private var nameTextField: NoBorderTextField!
    private var privacyButton: SettingButton!
    private var deleteAccountButton: SettingButton!
    private var signOutButton: SettingButton!
    
    override func viewWillAppear(_ animated: Bool) {

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: 24) as Any, NSAttributedString.Key.foregroundColor: UIColor.mainBlue]
        navigationController?.navigationBar.tintColor = .mainBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        self.navigationItem.title = "Settings"
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configNameButton()
        configPrivacyButton()
        configDeleteAccountButton()
        configSignOutButton()
    }
    
    @objc func tapName(sender: SettingButton) {
        nameTextField.becomeFirstResponder()
    }
    
    @objc private func nameEndEditing(_ textField: UITextField) {
        
        guard let currentUser = MemberModel.shared.current else { return }
        MemberModel.shared.current?.name = textField.text ?? currentUser.name
        MemberModel.shared.updateCurrentUser()
        view.endEditing(true)
    }
}

extension SettingViewController {
    
    private func configNameButton() {
        nameButton = SettingButton(self, action: #selector(tapName), text: "Name", textfromCenterY: -18, img: Img.iconsProfileSelected, imgSize: 96)
        let shadow = ShadowView(cornerRadius: 10, color: .mainBlue, offset: CGSize(width: 1.0, height: 3.0), opacity: 0.2, radius: 10)
        
        guard let currentUser = MemberModel.shared.current else { return }
        nameTextField = NoBorderTextField(bgColor: .lightBlueGrey, textColor: .mainBlue)
        nameTextField.font = UIFont.regular(size: 18)
        nameTextField.setLeftPaddingPoints(amount: 10)
        nameTextField.text = currentUser.name
        nameTextField.addTarget(self, action: #selector(nameEndEditing), for: .editingDidEnd)
        
        view.addSubview(shadow)
        view.addSubview(nameButton)
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            nameButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            nameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            nameButton.heightAnchor.constraint(equalToConstant: 100),
            
            shadow.topAnchor.constraint(equalTo: nameButton.topAnchor),
            shadow.bottomAnchor.constraint(equalTo: nameButton.bottomAnchor),
            shadow.leadingAnchor.constraint(equalTo: nameButton.leadingAnchor),
            shadow.trailingAnchor.constraint(equalTo: nameButton.trailingAnchor),
            
            nameTextField.bottomAnchor.constraint(equalTo: nameButton.bottomAnchor, constant: -18),
            nameTextField.heightAnchor.constraint(equalToConstant: 32),
            nameTextField.leadingAnchor.constraint(equalTo: nameButton.leadingAnchor, constant: 22),
            nameTextField.widthAnchor.constraint(equalTo: nameButton.widthAnchor, multiplier: 1 / 2)
        ])
    }
    
    private func configPrivacyButton() {
        privacyButton = SettingButton(self, action: #selector(tapName), text: "Privacy policy", textfromCenterY: 0, img: Img.iconsPrivacy, imgSize: 88)
        let shadow = ShadowView(cornerRadius: 10, color: .mainBlue, offset: CGSize(width: 1.0, height: 3.0), opacity: 0.2, radius: 10)
        
        view.addSubview(shadow)
        view.addSubview(privacyButton)
        NSLayoutConstraint.activate([
            privacyButton.topAnchor.constraint(equalTo: nameButton.bottomAnchor, constant: 24),
            privacyButton.leadingAnchor.constraint(equalTo: nameButton.leadingAnchor),
            privacyButton.trailingAnchor.constraint(equalTo: nameButton.trailingAnchor),
            privacyButton.heightAnchor.constraint(equalToConstant: 88),
            
            shadow.topAnchor.constraint(equalTo: privacyButton.topAnchor),
            shadow.bottomAnchor.constraint(equalTo: privacyButton.bottomAnchor),
            shadow.leadingAnchor.constraint(equalTo: privacyButton.leadingAnchor),
            shadow.trailingAnchor.constraint(equalTo: privacyButton.trailingAnchor)
        ])
    }
    
    private func configDeleteAccountButton() {
        deleteAccountButton = SettingButton(self, action: #selector(tapName), text: "Delete account", textfromCenterY: 0, img: Img.iconsCry, imgSize: 88)
        let shadow = ShadowView(cornerRadius: 10, color: .mainBlue, offset: CGSize(width: 1.0, height: 3.0), opacity: 0.2, radius: 10)
        
        view.addSubview(shadow)
        view.addSubview(deleteAccountButton)
        NSLayoutConstraint.activate([
            deleteAccountButton.topAnchor.constraint(equalTo: privacyButton.bottomAnchor, constant: 24),
            deleteAccountButton.leadingAnchor.constraint(equalTo: nameButton.leadingAnchor),
            deleteAccountButton.trailingAnchor.constraint(equalTo: nameButton.trailingAnchor),
            deleteAccountButton.heightAnchor.constraint(equalToConstant: 88),
            
            shadow.topAnchor.constraint(equalTo: deleteAccountButton.topAnchor),
            shadow.bottomAnchor.constraint(equalTo: deleteAccountButton.bottomAnchor),
            shadow.leadingAnchor.constraint(equalTo: deleteAccountButton.leadingAnchor),
            shadow.trailingAnchor.constraint(equalTo: deleteAccountButton.trailingAnchor)
        ])
    }
    
    private func configSignOutButton() {
        signOutButton = SettingButton(self, action: #selector(tapName), text: "Sign out", textfromCenterY: 0, img: Img.iconsSignOut, imgSize: 88)
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
