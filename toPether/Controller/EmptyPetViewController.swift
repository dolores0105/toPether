//
//  EmptyPetViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/3.
//

import UIKit

class EmptyPetViewController: UIViewController {
    
    private var welcomeLabel: MediumLabel!
    private var guideLabel: MediumLabel!
    private var createButton: RoundButton!
    private var getInvitationButton: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configWelcomeLabel()
        configGuideLabel()
        configCreateButton()
        configGetInvitationButton()
    }
}

extension EmptyPetViewController {
    private func configWelcomeLabel() {
        welcomeLabel = MediumLabel(size: 19, text: "Hello \(MemberModel.shared.current?.name ?? "")", textColor: .mainBlue)
        welcomeLabel.numberOfLines = 1
        view.addSubview(welcomeLabel)
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func configGuideLabel() {
        guideLabel = MediumLabel(size: 16, text: "Now, keep a pet", textColor: .mainBlue)
        view.addSubview(guideLabel)
        NSLayoutConstraint.activate([
            guideLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 18),
            guideLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            guideLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    func configCreateButton() {
        createButton = RoundButton(text: "Create one", size: 18)
        createButton.addTarget(self, action: #selector(tapCreate), for: .touchUpInside)
        view.addSubview(createButton)
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 40),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    func configGetInvitationButton() {
        getInvitationButton = RoundButton(text: "Get invitation", size: 18)
        getInvitationButton.addTarget(self, action: #selector(tapGetInvitation), for: .touchUpInside)
        view.addSubview(getInvitationButton)
        NSLayoutConstraint.activate([
            getInvitationButton.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: 32),
            getInvitationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            getInvitationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    @objc func tapCreate(_: RoundButton) {
        guard let currenUser = MemberModel.shared.current else { return }
        let addPetViewController = AddPetViewController(currentUser: currenUser, selectedPet: nil, isFirstSignIn: true)
        addPetViewController.modalPresentationStyle = .fullScreen
        self.present(addPetViewController, animated: true, completion: nil)
    }
    
    @objc func tapGetInvitation(_: RoundButton) {
        guard let currenUser = MemberModel.shared.current else { return }
        let getInvitationVC = GetInvitationViewController(currentUser: currenUser, isFirstSignIn: true)
//        getInvitationVC.modalPresentationStyle = .fullScreen
        self.present(getInvitationVC, animated: true, completion: nil)
    }
}
