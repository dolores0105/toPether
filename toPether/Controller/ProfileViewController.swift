//
//  ProfileViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/20.
//

import UIKit
import IQKeyboardManagerSwift

class ProfileViewController: UIViewController {
    
    var navigationBackgroundView: NavigationBackgroundView!
    var nameTitleLabel: UILabel!
    var iconImageView: UIImageView!
    var editNameButton: IconButton!
    var textField: WhiteBorderTextField!
    var memberName: String? {
        didSet {
            if memberName != nil && memberName == "" {
                textField.isEnabled = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Navigation controller
        self.navigationItem.title = "Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: 24), NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Img.iconsQrcode.obj, style: .plain, target: self, action: #selector(tapQrcode))
        
        navigationBackgroundView = NavigationBackgroundView()
        view.addSubview(navigationBackgroundView)
        NSLayoutConstraint.activate([
            navigationBackgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: -20),
            navigationBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBackgroundView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        nameTitleLabel = UILabel()
        nameTitleLabel.text = "Name"
        nameTitleLabel.textColor = .white
        nameTitleLabel.font = UIFont.medium(size: 18)
        view.addSubview(nameTitleLabel)
        nameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            nameTitleLabel.widthAnchor.constraint(equalToConstant: 60),
            nameTitleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        editNameButton = IconButton(self, action: #selector(tapEditName), img: Img.iconsEdit)
        editNameButton.backgroundColor = .mainBlue
        view.addSubview(editNameButton)
        NSLayoutConstraint.activate([
            editNameButton.centerYAnchor.constraint(equalTo: nameTitleLabel.centerYAnchor),
            editNameButton.leadingAnchor.constraint(equalTo: nameTitleLabel.trailingAnchor, constant: 20),
            editNameButton.widthAnchor.constraint(equalToConstant: 60),
            editNameButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        textField = WhiteBorderTextField(name: memberName)
        textField.delegate = self
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2 / 3)
        ])
        
    }
    
    // MARK: functions
    @objc func tapQrcode(sender: UIBarButtonItem) {
        
    }
    
    @objc func tapEditName(sender: UIButton) {
        textField.isEnabled = true
        textField.layer.borderWidth = 1
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        memberName = textField.text
        self.view.endEditing(true)
        if textField.hasText {
            textField.isEnabled = false
            textField.layer.borderWidth = 0
        } else {
            textField.isEnabled = true
            textField.layer.borderWidth = 1
        }
    }
}
