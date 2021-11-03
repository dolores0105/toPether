//
//  EmptyPetViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/3.
//

import UIKit

class EmptyPetViewController: UIViewController {
    
    private var label: MediumLabel!
    private var createButton: RoundButton!
    private var getInvitationButton: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configlabel()
        configCreateButton()
        configGetInvitationButton()
    }
}

extension EmptyPetViewController {
    func configlabel() {
        label = MediumLabel(size: 20, text: "Hello \(MemberModel.shared.current?.name ?? "")! \nNow, keep a pet", textColor: .mainBlue)
        label.numberOfLines = 2
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    func configCreateButton() {
        createButton = RoundButton(text: "Create one", size: 18)
        createButton.addTarget(self, action: #selector(tapCreate), for: .touchUpInside)
        view.addSubview(createButton)
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 32),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    func configGetInvitationButton() {
        getInvitationButton = RoundButton(text: "Get invitation", size: 18)
        getInvitationButton.addTarget(self, action: #selector(tapGetInvitation), for: .touchUpInside)
        view.addSubview(getInvitationButton)
        NSLayoutConstraint.activate([
            getInvitationButton.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: 20),
            getInvitationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            getInvitationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    @objc func tapCreate(_: RoundButton) {
        print("Create")
    }
    
    @objc func tapGetInvitation(_: RoundButton) {
        print("tapGetInvitation")
    }
}
