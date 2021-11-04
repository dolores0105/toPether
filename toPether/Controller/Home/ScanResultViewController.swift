//
//  ScanResultViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/4.
//

import UIKit

protocol ScanResultViewControllerDelegate: AnyObject {
    func dismissScanResult()
}

class ScanResultViewController: UIViewController {
    
    convenience init(pet: Pet, scannedMemberId: String) {
        self.init()
        self.pet = pet
        self.scannedMemberId = scannedMemberId
    }
    private var pet: Pet!
    private var scannedMemberId: String!
    
    private var animator: UIViewPropertyAnimator!
    private var floatingView: UIView! {
        didSet {
            floatingView.layer.cornerRadius = 10
            floatingView.layer.masksToBounds = true
        }
    }
    
    private var titleLabel: MediumLabel!
    private var contentLabel: RegularLabel!
    private var confirmButton: RoundButton!
    private var cancelButton: BorderButton!
//    private var animationView: AnimationView!
    
    weak var delegate: ScanResultViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.6,
            delay: 0,
            options: [.curveEaseOut]) {
                self.view.backgroundColor = UIColor(white: 0, alpha: 0.4)
                self.floatingView.transform = .identity
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        floatingView = UIView()
        floatingView.backgroundColor = .white
        floatingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(floatingView)
        NSLayoutConstraint.activate([
            floatingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            floatingView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            floatingView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2 / 3),
            floatingView.heightAnchor.constraint(equalTo: floatingView.widthAnchor, constant: 32)
        ])
        
        floatingView.transform = CGAffineTransform(translationX: 0, y: floatingView.bounds.height)
        
        configTitleLabel()
        configContentLabel()
        configConfirmButton()
        configCancelButton()
        
        let pan = UIPanGestureRecognizer(
            target: self,
            action: #selector(panOnFloatingView(_:)))
        floatingView.isUserInteractionEnabled = true
        floatingView.addGestureRecognizer(pan)
        
        queryMember(memberId: scannedMemberId)
    }
    
    func queryMember(memberId: String) {
        // check the invitedMemberId that user inputs is existing
        MemberModel.shared.queryMember(id: memberId) { [weak self] member in
            guard let self = self else { return }
            if let member = member { // the member is existing
                if !member.petIds.contains(self.pet.id) { // the member hasn't join the pet group
                    self.contentLabel.text = "Do you want to invite \(member.name)?"
                    /* confirm button action =
                     1. member.petIds.append(self.pet.id)
                        MemberModel.shared.updateMember(member: member)
                     2. self.pet.memberIds.append(member.id)
                        PetModel.shared.updatePet(id: self.pet.id, pet: self.pet)
                     3. self.animationView.isHidden = false
                        self.animationView?.play(completion: { _ in
                        self.navigationController?.popViewController(animated: true)
                        })
                     */
                }
                
                if self.pet.memberIds.contains(member.id) {
                    self.contentLabel.text = "\(member.name) is already in the group"
                    // confirm button action = dismiss scanResultVC
                }
                
            } else {
                self.contentLabel.text = "The member does not exist"
            }
        }
    }
    
    @objc private func panOnFloatingView(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            animator = UIViewPropertyAnimator(
                duration: 0.6,
                curve: .easeOut) {
                    let translationY = self.floatingView.bounds.height
                    self.floatingView.transform = CGAffineTransform(translationX: 0, y: translationY)
                    self.view.backgroundColor = .clear
                }
            
        case .changed:
            let translation = recognizer.translation(in: floatingView)
            let fractionComplete = translation.y / floatingView.bounds.height
            animator.fractionComplete = fractionComplete
            
        case .ended:
            if animator.fractionComplete <= 0.5 {
                animator.isReversed = true
                
            } else {
                animator.addCompletion { [weak self] _ in
                    guard let self = self else { return }
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.dismissScanResult()
                }
            }
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            break
        }
    }
}

extension ScanResultViewController {
    
    func configTitleLabel() {
        titleLabel = MediumLabel(size: 24, text: "Scan success", textColor: .mainBlue)
        titleLabel.textAlignment = .center
        floatingView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: floatingView.topAnchor, constant: 32),
            titleLabel.centerXAnchor.constraint(equalTo: floatingView.centerXAnchor)
        ])
    }
    
    func configContentLabel() {
        contentLabel = RegularLabel(size: 18, text: nil, textColor: .mainBlue)
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .center
        floatingView.addSubview(contentLabel)
        NSLayoutConstraint.activate([
            contentLabel.centerYAnchor.constraint(equalTo: floatingView.centerYAnchor, constant: -12),
            contentLabel.leadingAnchor.constraint(equalTo: floatingView.leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: floatingView.trailingAnchor, constant: -16)
        ])
    }
    
    func configConfirmButton() {
        confirmButton = RoundButton(text: "OK", size: 18)
        floatingView.addSubview(confirmButton)
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: floatingView.bottomAnchor, constant: -20),
            confirmButton.trailingAnchor.constraint(equalTo: floatingView.trailingAnchor, constant: -20),
            confirmButton.widthAnchor.constraint(equalTo: floatingView.widthAnchor, multiplier: 0.5, constant: -20)
        ])
    }
    
    func configCancelButton() {
        cancelButton = BorderButton()
        cancelButton.layer.borderWidth = 0
        cancelButton.setTitle("cancel", for: .normal)
        cancelButton.setTitleColor(.deepBlueGrey, for: .normal)
        cancelButton.titleLabel?.font = UIFont.medium(size: 18)
        floatingView.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: floatingView.bottomAnchor, constant: -20),
            cancelButton.leadingAnchor.constraint(equalTo: floatingView.leadingAnchor, constant: 16),
            cancelButton.widthAnchor.constraint(equalTo: floatingView.widthAnchor, multiplier: 0.5, constant: -28),
            cancelButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
