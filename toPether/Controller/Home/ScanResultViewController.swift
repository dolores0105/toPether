//
//  ScanResultViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/4.
//

import UIKit
import Lottie

protocol ScanResultViewControllerDelegate: AnyObject {
    func dismissScanResult()
    func backToHomeVC()
}

class ScanResultViewController: UIViewController {
    
    convenience init(pet: Pet, scannedMemberId: String) {
        self.init()
        self.pet = pet
        self.scannedMemberId = scannedMemberId
    }
    private var pet: Pet!
    private var scannedMemberId: String!
    private var scannedMember: Member?
    
    private var animator: UIViewPropertyAnimator!
    
    weak var delegate: ScanResultViewControllerDelegate?
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configFloatingView()
        configTitleLabel()
        configPetImageView()
        configContentLabel()
        configCancelButton()
        
        queryMember(memberId: scannedMemberId)
    }
    
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
    
    // MARK: - Data Functions
    
    private func queryMember(memberId: String) {
        // check the invitedMemberId that user inputs is existing
        MemberManager.shared.queryMember(id: memberId) { [weak self] member in
            guard let self = self else { return }
            if let member = member { // the member is existing
                
                self.scannedMember = member
                
                if !member.petIds.contains(self.pet.id) { // the member hasn't join the pet group
                    self.contentLabel.text = "We found \(member.name)!"
                    self.configInviteButton()
                }
                
                if self.pet.memberIds.contains(member.id) {
                    self.contentLabel.text = "\(member.name) has been in the group"

                    self.configOkButton()
                }
                
            } else {
                self.contentLabel.text = "The member does not exist"
            }
        }
    }
    
    // MARK: - @objc Functions
    
    @objc private func tapInvite() {
        guard let scannedMember = scannedMember else { return }
        scannedMember.petIds.append(self.pet.id)
        MemberManager.shared.updateMember(member: scannedMember)
        
        self.pet.memberIds.append(scannedMember.id)
        PetManager.shared.updatePet(id: pet.id, pet: pet) { result in
            switch result {
            case .success(let string):
                print(string)
                self.animationView.isHidden = false
                self.animationView.play(completion: { _ in
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.backToHomeVC()
                })
            case .failure(let error):
                self.presentErrorAlert(message: error.localizedDescription + " Please try again")
            }
        }
    }
    
    @objc private func tapConfirm() {
        self.dismiss(animated: true, completion: nil)
        delegate?.backToHomeVC()
    }
    
    @objc private func tapCancel() {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.dismissScanResult()
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
    
    // MARK: - UI Properties
    
    private lazy var floatingView: UIView = {
            
        let floatingView = UIView()
        floatingView.backgroundColor = .white
        floatingView.translatesAutoresizingMaskIntoConstraints = false
        
        floatingView.transform = CGAffineTransform(translationX: 0, y: floatingView.bounds.height)
        
        floatingView.layer.cornerRadius = 10
        floatingView.layer.masksToBounds = true
        
        let pan = UIPanGestureRecognizer(
            target: self,
            action: #selector(panOnFloatingView(_:)))
        floatingView.isUserInteractionEnabled = true
        floatingView.addGestureRecognizer(pan)
        
        return floatingView
    }()
    
    private lazy var titleLabel: MediumLabel = {
        let titleLabel = MediumLabel(size: 24, text: "Scan success", textColor: .mainBlue)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private lazy var petImageView: UIImageView = {
        let petImageView = UIImageView(image: pet.photoImage)
        petImageView.layer.cornerRadius = 10
        petImageView.clipsToBounds = true
        petImageView.contentMode = .scaleAspectFill
        petImageView.translatesAutoresizingMaskIntoConstraints = false
        return petImageView
    }()
    
    private lazy var contentLabel: RegularLabel = {
        let contentLabel = RegularLabel(size: 18, text: nil, textColor: .mainBlue)
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .center
        return contentLabel
    }()
    
    private var confirmButton: RoundButton!
    
    private var cancelButton: BorderButton = {
        let cancelButton = BorderButton()
        cancelButton.layer.borderWidth = 0
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.deepBlueGrey, for: .normal)
        cancelButton.titleLabel?.font = UIFont.medium(size: 18)
        cancelButton.addTarget(self, action: #selector(tapCancel), for: .touchUpInside)
        return cancelButton
    }()
    
    private lazy var animationView = LottieAnimation.shared.createOneTimeAnimation(lottieName: "lottieSuccess")
}

// MARK: - UI configure extension

extension ScanResultViewController {
    
    private func configFloatingView() {
        view.addSubview(floatingView)
        NSLayoutConstraint.activate([
            floatingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            floatingView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            floatingView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2 / 3),
            floatingView.heightAnchor.constraint(equalTo: floatingView.widthAnchor, constant: 72)
        ])
    }
    
    private func configTitleLabel() {
        floatingView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: floatingView.topAnchor, constant: 32),
            titleLabel.centerXAnchor.constraint(equalTo: floatingView.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 26)
        ])
    }
    
    private func configPetImageView() {
        floatingView.addSubview(petImageView)
        NSLayoutConstraint.activate([
            petImageView.widthAnchor.constraint(equalToConstant: 80),
            petImageView.heightAnchor.constraint(equalTo: petImageView.widthAnchor),
            petImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            petImageView.centerXAnchor.constraint(equalTo: floatingView.centerXAnchor)
        ])
    }
    
    private func configContentLabel() {
        floatingView.addSubview(contentLabel)
        NSLayoutConstraint.activate([
            contentLabel.centerYAnchor.constraint(equalTo: floatingView.centerYAnchor, constant: 25),
            contentLabel.leadingAnchor.constraint(equalTo: floatingView.leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: floatingView.trailingAnchor, constant: -16)
        ])
    }
    
    private func configInviteButton() {
        confirmButton = RoundButton(text: "Invite", size: 18)
        confirmButton.addTarget(self, action: #selector(tapInvite), for: .touchUpInside)
        floatingView.addSubview(confirmButton)
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: floatingView.bottomAnchor, constant: -20),
            confirmButton.trailingAnchor.constraint(equalTo: floatingView.trailingAnchor, constant: -20),
            confirmButton.widthAnchor.constraint(equalTo: floatingView.widthAnchor, multiplier: 0.5, constant: -20)
        ])
        
        configLottieAnimation()
    }
    
    private func configOkButton() {
        confirmButton = RoundButton(text: "OK", size: 18)
        confirmButton.addTarget(self, action: #selector(tapConfirm), for: .touchUpInside)
        floatingView.addSubview(confirmButton)
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: floatingView.bottomAnchor, constant: -20),
            confirmButton.trailingAnchor.constraint(equalTo: floatingView.trailingAnchor, constant: -20),
            confirmButton.leadingAnchor.constraint(equalTo: floatingView.leadingAnchor, constant: 20)
        ])
    }
    
    private func configCancelButton() {
        floatingView.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: floatingView.bottomAnchor, constant: -20),
            cancelButton.leadingAnchor.constraint(equalTo: floatingView.leadingAnchor, constant: 16),
            cancelButton.widthAnchor.constraint(equalTo: floatingView.widthAnchor, multiplier: 0.5, constant: -28),
            cancelButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func configLottieAnimation() {
        animationView.isHidden = true
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor)
        ])
    }
}
