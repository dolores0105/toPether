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
    var memberId: String!
    
    private var inputTitleLabel: MediumLabel!
    private var idTextField: BlueBorderTextField!
    private var okButton: RoundButton!
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Navigation controller
        self.navigationItem.title = "Invite a member"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.medium(size: 24) as Any, NSAttributedString.Key.foregroundColor: UIColor.mainBlue]
        
        view.backgroundColor = .white
        
        print(pet.name)
        
        inputTitleLabel = MediumLabel(size: 16)
        inputTitleLabel.textColor = .mainBlue
        inputTitleLabel.text = "User ID"
        view.addSubview(inputTitleLabel)
        NSLayoutConstraint.activate([
            inputTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            inputTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            inputTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        idTextField = BlueBorderTextField(text: nil)
        idTextField.setLeftPaddingPoints(amount: 12)
        idTextField.delegate = self
        view.addSubview(idTextField)
        NSLayoutConstraint.activate([
            idTextField.topAnchor.constraint(equalTo: inputTitleLabel.bottomAnchor, constant: 8),
            idTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            idTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        okButton = RoundButton(text: "ok", size: 18)
        okButton.isEnabled = false
        okButton.backgroundColor = .lightBlueGrey
        okButton.addTarget(self, action: #selector(tapOK), for: .touchUpInside)
        view.addSubview(okButton)
        NSLayoutConstraint.activate([
            okButton.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 40),
            okButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            okButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    // MARK: functions
    @objc func tapOK(sender: UIButton) {
        // add petId to member's petIds
        // add memberId to pet's memberIds
        
        navigationController?.popViewController(animated: true)
    }
}

extension InviteViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let id = idTextField.text else {
            okButton.isEnabled = false
            okButton.backgroundColor = .lightBlueGrey
            return
        }
        okButton.isEnabled = true
        okButton.backgroundColor = .mainYellow
        
        memberId = id
        print("input memberId", memberId ?? "")
    }
}
