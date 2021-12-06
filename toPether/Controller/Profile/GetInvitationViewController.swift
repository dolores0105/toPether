//
//  GetInvitationViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/26.
//

import UIKit

class GetInvitationViewController: UIViewController {
    
    convenience init(currentUser: Member, isFirstSignIn: Bool) {
        self.init()
        self.currentUser = currentUser
        self.isFirstSignIn = isFirstSignIn
    }
    private var currentUser: Member!
    private var isFirstSignIn: Bool!
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configTitleLabel()
        configGuideLabel()
        configQrCodeView()
        configQrCodeImageView()
        configAnimationView()
        
        addListener()
    }
    
    // MARK: - Data functions
    
    private func addListener() {
        MemberManager.shared.addUserListener { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(.added(data: _ )), .success(.removed(data: _ )):
                break
            case .success(.modified(data: _ )):
                self.animationView.play(completion: { _ in
                    
                    if self.isFirstSignIn {
                        let tabBarViewController = TabBarViewController()
                        
                        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                        sceneDelegate?.changeRootViewController(tabBarViewController)
                        
                    } else {
                        self.dismiss(animated: true) {
                            print("addUserListener at getInvitaionVC")
                        }
                    }
                    
                })
            case .failure(let error):
                print("lisener error at getInvitationVC", error)
                self.presentErrorAlert(message: error.localizedDescription + " Please try again")
            }
        }
    }
    
    private func createQrcode(id: String) -> CIImage? {
        
        let data = id.data(using: .isoLatin1)
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        
        qrFilter?.setValue(data, forKey: "inputMessage")
        qrFilter?.setValue("Q", forKey: "inputCorrectionLevel")
            
        return qrFilter?.outputImage
    }
    
    // MARK: - UI Properties
    
    private lazy var titleLabel: MediumLabel = {
        let titleLabel = MediumLabel(size: 24, text: "Get invitation", textColor: .mainBlue)
        return titleLabel
    }()
    
    private lazy var guideLabel: RegularLabel = {
        let guideLabel = RegularLabel(size: 18, text: "Show your code to join the pet group", textColor: .mainBlue)
        return guideLabel
    }()
    
    private lazy var qrCodeView: UIView = {
        let qrCodeView = UIView()
        qrCodeView.backgroundColor = .white
        qrCodeView.layer.cornerRadius = 10
        qrCodeView.setShadow(color: .mainBlue, offset: CGSize(width: 5.0, height: 5.0), opacity: 0.1, radius: 10)
        qrCodeView.translatesAutoresizingMaskIntoConstraints = false
        return qrCodeView
    }()
    
    private lazy var qrCodeImageView: UIImageView = {
        let qrCodeImageView = UIImageView()
        
        guard let qrcode = createQrcode(id: currentUser.id) else { return UIImageView() }
        let qrWidth = UIScreen.main.bounds.width / 3 * 2 - 64
        let qrheight = qrWidth
        let scaleX = qrWidth / qrcode.extent.width
        let scaleY = qrheight / qrcode.extent.height
        let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)

        qrCodeImageView.image = UIImage(ciImage: qrcode.transformed(by: transform))
        qrCodeImageView.translatesAutoresizingMaskIntoConstraints = false
        return qrCodeImageView
    }()
    
    private lazy var animationView = LottieAnimation.shared.createOneTimeAnimation(lottieName: "lottieSuccess")
}

// MARK: UI layouts

extension GetInvitationViewController {
    
    private func configTitleLabel() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configGuideLabel() {
        view.addSubview(guideLabel)
        NSLayoutConstraint.activate([
            guideLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 72),
            guideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configQrCodeView() {
        view.addSubview(qrCodeView)
        NSLayoutConstraint.activate([
            qrCodeView.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 56),
            qrCodeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            qrCodeView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2 / 3),
            qrCodeView.heightAnchor.constraint(equalTo: qrCodeView.widthAnchor)
        ])
    }
    
    private func configQrCodeImageView() {
        view.addSubview(qrCodeImageView)
        NSLayoutConstraint.activate([
            qrCodeImageView.topAnchor.constraint(equalTo: qrCodeView.topAnchor, constant: 32),
            qrCodeImageView.bottomAnchor.constraint(equalTo: qrCodeView.bottomAnchor, constant: -32),
            qrCodeImageView.leadingAnchor.constraint(equalTo: qrCodeView.leadingAnchor, constant: 32),
            qrCodeImageView.trailingAnchor.constraint(equalTo: qrCodeView.trailingAnchor, constant: -32)
        ])
    }
    
    private func configAnimationView() {
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor)
        ])
    }
}
