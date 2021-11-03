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
    
    private lazy var logoImageView = RoundCornerImageView(img: UIImage(named: "AppIcon"))
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            guard let current = Auth.auth().currentUser else { return }
            MemberModel.shared.queryCurrentUser(id: current.uid) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let current):
                    MemberModel.shared.current = current
                    self.gotoTabbarVC()
                    
                case .failure(let error):
                    print(error)
                    MemberModel.shared.setMember(uid: current.uid, completion: self.loginHandler)
                }
            }
            
        } else {
            view.backgroundColor = .white
            configLogoView()
            setupSignInButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    private func loginHandler(_ result: Result<Member, Error>) {
        switch result {
        case .success(let member):
            MemberModel.shared.current = member
//            gotoTabbarVC() // should go to empty setting pages
            gotoEmptySetting()
        case .failure(let error):
            print("loginHandler", error)
            // Response the error to USER
        }
    }
    
    private func gotoTabbarVC() {

        let tabBarViewController = TabBarViewController()
        tabBarViewController.modalPresentationStyle = .fullScreen
        self.present(tabBarViewController, animated: true, completion: nil)
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

                    MemberModel.shared.setMember(uid: user.uid, completion: self.loginHandler)

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
    
    func configLogoView() {

        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor)
            
        ])
    }
    
    func setupSignInButton() {
        let button = ASAuthorizationAppleIDButton(type: .default, style: .whiteOutline)
        button.addTarget(self, action: #selector(tapLoginButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 80),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
