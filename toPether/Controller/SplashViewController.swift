//
//  SplashViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/22.
//

import UIKit
import AuthenticationServices
import CryptoKit
import FirebaseAuth

class SplashViewController: UIViewController {
    
    private var bgView: UIView!
    private lazy var logoImageView = RoundCornerImageView(img: UIImage(named: "toPetherIcon"))
    private var logoNameImageView: UIImageView!
    private var faceBgView: UIView!
    private var faceImageView: UIImageView!
    private var privacyLabel: RegularLabel!
    private var privacyButton: UIButton!
    private lazy var signInWithAppleButton = ASAuthorizationAppleIDButton(type: .default, style: .whiteOutline)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let current = Auth.auth().currentUser {

            MemberModel.shared.queryCurrentUser(id: current.uid) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let current):
                    MemberModel.shared.current = current
                    self.gotoTabbarVC()
                    
                case .failure(let error):
                    print(error)
                    MemberModel.shared.setMember(uid: current.uid, name: current.displayName, completion: self.loginHandler)
                }
            }
            
        } else {
//            configBgView()
//            configLogoView()
            logoImageAnimation()
//            setupSignInButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configBgView()
        configLogoView()

    }
    
    @objc private func tapLoginButton() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email, .fullName]

        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self

        controller.performRequests()
    }
    
    private func loginHandler(_ result: Result<(Member, Bool), Error>) {
        switch result {
        case .success((let member, let isExist)):
            if isExist {
                MemberModel.shared.current = member
                gotoTabbarVC()
                
            } else {
                MemberModel.shared.current = member
                gotoEmptySetting()
            }
            
        case .failure(let error):
            print("loginHandler", error)
            // Response the error to USER
        }
    }
    
    private func gotoTabbarVC() {

        let tabBarViewController = TabBarViewController()
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.changeRootViewController(tabBarViewController)

    }
    
    private func gotoEmptySetting() {
        
        let emptyUserViewController = EmptyUserViewController()
        emptyUserViewController.modalPresentationStyle = .fullScreen
        self.present(emptyUserViewController, animated: true, completion: nil)
    }
}

extension SplashViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            // Retrieve the secure nonce generated during Apple sign in
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            // Retrieve Apple identity token
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            
            // Convert Apple identity token to string
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken).")
                return
            }

            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)

            Auth.auth().signIn(with: credential) { [weak self] (authDataResult, error) in
                guard let self = self else { return }
                if let user = authDataResult?.user {
                    print("Nice! You're now signed in as \(user.uid), email: \(user.email ?? "unknown")") // User is signed in to Firebase with Apple
                    
                    MemberModel.shared.setMember(uid: user.uid, name: appleIDCredential.fullName?.givenName, completion: self.loginHandler)

                } else if let error = error {
                    print("sign in error:", error.localizedDescription)
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        switch error {
        case ASAuthorizationError.canceled:
            break
        case ASAuthorizationError.failed:
            break
        case ASAuthorizationError.invalidResponse:
            break
        case ASAuthorizationError.notHandled:
            break
        case ASAuthorizationError.unknown:
            break
        default:
            break
        }
                    
        print("didCompleteWithError: \(error.localizedDescription)")
    }
}

extension SplashViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError(
                    "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                )
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    
    return result
}

// Unhashed nonce
private var currentNonce: String?

@available(iOS 13, *)
private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()
    
    return hashString
}

extension SplashViewController {
    
    private func logoImageAnimation() {

        UIView.animate(
            withDuration: 1.8,
            delay: 0.3,
            usingSpringWithDamping: 2.0,
            initialSpringVelocity: 1.0,
            options: .curveEaseIn) { [weak self] in
                guard let self = self else { return }
                let yTransform = CGAffineTransform(translationX: 0, y: -200)
                self.logoImageView.transform = yTransform
                self.bgView.alpha = 0
                
            } completion: { _ in
                self.configLogoNameImageView()
                self.nameAnimation()
            }
    }
    
    private func nameAnimation() {
        
        UIView.animate(
            withDuration: 0.9,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: .curveEaseIn) { [weak self] in
            guard let self = self else { return }
                self.logoNameImageView.alpha = 1
                
        } completion: { _ in
            self.configYellow()
            self.yellowAnimation()
        }
    }
    
    private func yellowAnimation() {
        
        UIView.animate(
            withDuration: 1.4,
            delay: 0.0,
            usingSpringWithDamping: 4.0,
            initialSpringVelocity: 1.0,
            options: .curveEaseIn) { [weak self] in
            guard let self = self else { return }
                let faceWidth = UIScreen.main.bounds.width + 100
                let yTransform = CGAffineTransform(translationX: 0, y: -(faceWidth / 2 + 24))
                self.faceBgView.transform = yTransform
                
        } completion: { _ in
            
            self.setupSignInButton()
            self.signInButtonAnimation()
        }
    }
    
    private func signInButtonAnimation() {
        
        UIView.animate(
            withDuration: 0.6,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: .curveEaseIn) { [weak self] in
            guard let self = self else { return }
                self.signInWithAppleButton.alpha = 1
                
        } completion: { _ in

        }
    }
}

extension SplashViewController {
    
    private func configBgView() {
        bgView = UIView()
        bgView.backgroundColor = .mainBlue
        bgView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bgView)
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: view.topAnchor),
            bgView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configLogoView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: 130),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor)
            
        ])
    }
    
    private func configLogoNameImageView() {
        logoNameImageView = UIImageView(image: Img.appNameBlue.obj)
        logoNameImageView.alpha = 0
        logoNameImageView.clipsToBounds = true
        logoNameImageView.contentMode = .scaleAspectFit
        logoNameImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoNameImageView)
        NSLayoutConstraint.activate([
            logoNameImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            logoNameImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoNameImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            logoNameImageView.heightAnchor.constraint(equalTo: logoNameImageView.widthAnchor, multiplier: 3.44)
        ])
    }
    
    private func configYellow() {
        let faceWidth = UIScreen.main.bounds.width + 100
        
        faceBgView = UIView()
        faceBgView.backgroundColor = .mainYellow
        faceBgView.layer.cornerRadius = faceWidth / 2
        faceBgView.translatesAutoresizingMaskIntoConstraints = false
        
        faceImageView = UIImageView(image: Img.iconsFace.obj)
        faceImageView.clipsToBounds = true
        faceImageView.contentMode = .scaleAspectFit
        faceImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(faceBgView)
        faceBgView.addSubview(faceImageView)
        NSLayoutConstraint.activate([
            faceBgView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            faceBgView.widthAnchor.constraint(equalToConstant: faceWidth),
            faceBgView.heightAnchor.constraint(equalToConstant: faceWidth),
            faceBgView.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: (faceWidth / 2) + 24),
            
            faceImageView.topAnchor.constraint(equalTo: faceBgView.topAnchor, constant: 16),
            faceImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            faceImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 4),
            faceImageView.heightAnchor.constraint(equalTo: faceImageView.widthAnchor, multiplier: 0.55)
        ])
    }
    
    private func setupSignInButton() {

        signInWithAppleButton.addTarget(self, action: #selector(tapLoginButton), for: .touchUpInside)
        signInWithAppleButton.alpha = 0
        signInWithAppleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signInWithAppleButton)
        NSLayoutConstraint.activate([
            signInWithAppleButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            signInWithAppleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInWithAppleButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            signInWithAppleButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        view.bringSubviewToFront(signInWithAppleButton)
    }
}
