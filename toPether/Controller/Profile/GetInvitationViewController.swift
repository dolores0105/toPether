//
//  GetInvitationViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/26.
//

import UIKit
import Lottie

class GetInvitationViewController: UIViewController {
    
    convenience init(currentUser: Member) {
        self.init()
        self.currentUser = currentUser
    }
    private var currentUser: Member!
    
    private var invitationTitleLabel: MediumLabel!
    private var currentUserIdLabel: MediumLabel!
    private var animationView: AnimationView!
    
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
        
        animationView = .init(name: "LottieDone")
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor)
        ])
        
        // MARK: data
        MemberModel.shared.addUserListener { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(.added(members: _ )):
                break
            case .success(.modified(members: _ )):
                self.animationView?.play(completion: { (finished) in
                    self.dismiss(animated: true) {
                        print("addUserListener at getInvitaionVC")
                    }
                })
                
            case .success(.removed(members: _ )):
                break
            case .failure(let error):
                print("lisener error at getInvitationVC", error)
            }
        }
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
