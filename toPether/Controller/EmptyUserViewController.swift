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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configLabel()
        configNameTextField()
        configButton()
    }
}

extension EmptyUserViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if nameTextField.hasText {
            
            nextButton.isEnabled = true
            nextButton.backgroundColor = .mainYellow
            
            MemberModel.shared.current?.name = nameTextField.text ?? ""
            MemberModel.shared.updateCurrentUser()
            
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .lightBlueGrey
        }
    }
}

extension EmptyUserViewController {
    
    func configLabel() {
        label = MediumLabel(size: 18, text: "What should we call you?", textColor: .mainBlue)
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    func configNameTextField() {
        nameTextField = BlueBorderTextField(text: nil)
        nameTextField.delegate = self
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    func configButton() {
        nextButton = RoundButton(text: "Next", size: 18)
        nextButton.isEnabled = false
        nextButton.backgroundColor = .lightBlueGrey
        nextButton.addTarget(self, action: #selector(tapNext), for: .touchUpInside)
        view.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 56),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    @objc func tapNext(_: RoundButton) {
        let emptyPetViewController = EmptyPetViewController()
        emptyPetViewController.modalPresentationStyle = .fullScreen
        self.present(emptyPetViewController, animated: true, completion: nil)
    }
}
