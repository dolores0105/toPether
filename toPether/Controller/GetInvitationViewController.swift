//
//  GetInvitationViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/26.
//

import UIKit

class GetInvitationViewController: UIViewController {
    
    convenience init(currentUser: Member) {
        self.init()
        self.currentUser = currentUser
    }
    private var currentUser: Member!
    
    private var invitationTitleLabel: MediumLabel!
    private var currentUserIdLabel: MediumLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        invitationTitleLabel = MediumLabel(size: 24, text: "Get invitation", textColor: .mainBlue)
        view.addSubview(invitationTitleLabel)
        NSLayoutConstraint.activate([
            invitationTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            invitationTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        currentUserIdLabel = MediumLabel(size: 18, text: currentUser.id, textColor: .mainBlue)
        view.addSubview(currentUserIdLabel)
        NSLayoutConstraint.activate([
            currentUserIdLabel.topAnchor.constraint(equalTo: invitationTitleLabel.bottomAnchor, constant: 64),
            currentUserIdLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        currentUserIdLabel.isUserInteractionEnabled = true
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        currentUserIdLabel.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handleLongPress(recognizer: UIGestureRecognizer) {
        if let view = recognizer.view, let superview = recognizer.view?.superview {
            view.becomeFirstResponder()
            
            let menu = UIMenuController.shared
            
            let copyItem = UIMenuItem(title: "Copy", action: #selector(copyAction))
            menu.menuItems = [copyItem]
            
            menu.showMenu(from: superview, rect: view.frame)
        }
    }
    
    @objc func copyAction(sender: UILabel) {
        UIPasteboard.general.setValue(self.currentUserIdLabel.text ?? "", forPasteboardType: "public.utf8-plain-text")
        
        let menu = UIMenuController.shared
        menu.hideMenu()
    }
}
