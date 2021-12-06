//
//  EmptyUserViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/3.
//

import UIKit

class EmptyUserViewController: UIViewController {

    private var label: MediumLabel!
    private var nameTextField: BlueBorderTextField!
    private var nextButton: RoundButton!
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configLabel()
        configNameTextField()
        configButton()
    }
    
    // MARK: - @objc Functions
    
    @objc private func tapNext(_: RoundButton) {
        let emptyPetViewController = EmptyPetViewController()
        emptyPetViewController.modalPresentationStyle = .fullScreen
        self.present(emptyPetViewController, animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension EmptyUserViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {

        buttonIsEnabled()
    }
}

// MARK: - UI Configure Functions

extension EmptyUserViewController {
    
    private func configLabel() {
        label = MediumLabel(size: 19, text: "What should we call you?", textColor: .mainBlue)
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configNameTextField() {
        nameTextField = BlueBorderTextField(text: nil)
        nameTextField.becomeFirstResponder()
        nameTextField.text = MemberManager.shared.current?.name
        nameTextField.delegate = self
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configButton() {
        nextButton = RoundButton(text: "Next", size: 18)
        buttonIsEnabled()
        nextButton.addTarget(self, action: #selector(tapNext), for: .touchUpInside)
        view.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 56),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func buttonIsEnabled() {
        if nameTextField.hasText {
            
            nextButton.isEnabled = true
            nextButton.backgroundColor = .mainYellow
            
            MemberManager.shared.current?.name = nameTextField.text ?? ""
            MemberManager.shared.updateCurrentUser()
            
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .lightBlueGrey
        }
    }
}
