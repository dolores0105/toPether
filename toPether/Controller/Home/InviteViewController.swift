//
//  InviteViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/25.
//

import UIKit
import Lottie

class InviteViewController: UIViewController {
    
    convenience init(pet: Pet) {
        self.init()
        self.pet = pet
    }
    private var pet: Pet!
    var memberId: String!
    
    private var inputTitleLabel: MediumLabel!
    private var idTextField: BlueBorderTextField!
    private var wrongInputLabel: RegularLabel!
    private var okButton: RoundButton!
    private var animationView: AnimationView!
    
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
        
        inputTitleLabel = MediumLabel(size: 16, text: "User ID", textColor: .mainBlue)
        inputTitleLabel.textColor = .mainBlue
        inputTitleLabel.text = "User ID"
        view.addSubview(inputTitleLabel)
        NSLayoutConstraint.activate([
            inputTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            inputTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            inputTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        idTextField = BlueBorderTextField(text: nil)
        idTextField.delegate = self
        view.addSubview(idTextField)
        NSLayoutConstraint.activate([
            idTextField.topAnchor.constraint(equalTo: inputTitleLabel.bottomAnchor, constant: 8),
            idTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            idTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        wrongInputLabel = RegularLabel(size: 14, text: "Could not find this user.", textColor: .red)
        wrongInputLabel.isHidden = true
        view.addSubview(wrongInputLabel)
        NSLayoutConstraint.activate([
            wrongInputLabel.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 8),
            wrongInputLabel.leadingAnchor.constraint(equalTo: idTextField.leadingAnchor),
            wrongInputLabel.trailingAnchor.constraint(equalTo: idTextField.trailingAnchor)
        ])
        
        okButton = RoundButton(text: "ok", size: 18)
        okButton.isEnabled = false
        okButton.backgroundColor = .lightBlueGrey
        okButton.addTarget(self, action: #selector(tapOK), for: .touchUpInside)
        view.addSubview(okButton)
        NSLayoutConstraint.activate([
            okButton.topAnchor.constraint(equalTo: wrongInputLabel.bottomAnchor, constant: 32),
            okButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            okButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        animationView = .init(name: "LottieDone")
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.isHidden = true
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor)
        ])
    }
    
    // MARK: functions
    @objc func tapOK(sender: UIButton) {
        // check the memberId that user inputs is existing
        MemberModel.shared.queryMember(id: memberId) { [weak self] member in
            guard let self = self else { return }
            if let member = member {
                print("the member is existing", member.id)
                // add petId to member's petIds
                if !member.petIds.contains(self.pet.id) {
                    member.petIds.append(self.pet.id)
                    MemberModel.shared.updateMember(member: member)
                }
                
                // add memberId to pet's memberIds
                if !self.pet.memberIds.contains(member.id) {
                    self.pet.memberIds.append(member.id)
                    PetModel.shared.updatePet(id: self.pet.id, pet: self.pet)
                    
                    self.animationView.isHidden = false
                    self.animationView?.play(completion: { _ in
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                } else {
                    self.idTextField.text = ""
                    self.idTextField.becomeFirstResponder()
                    self.wrongInputLabel.isHidden = false
                    self.wrongInputLabel.text = "You've toPether \(self.pet.name)."
                    self.okButton.isEnabled = false
                    self.okButton.backgroundColor = .lightBlueGrey
                }

            } else {
                print("NOT existing")
                self.idTextField.text = ""
                self.idTextField.becomeFirstResponder()
                self.wrongInputLabel.isHidden = false
                self.okButton.isEnabled = false
                self.okButton.backgroundColor = .lightBlueGrey
            }
        }
    }
}

extension InviteViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard idTextField.hasText else {
            okButton.isEnabled = false
            okButton.backgroundColor = .lightBlueGrey
            return
        }
        okButton.isEnabled = true
        okButton.backgroundColor = .mainYellow
        
        memberId = idTextField.text
        print("input memberId", memberId ?? "")
    }
}
