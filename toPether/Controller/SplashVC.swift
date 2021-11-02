//
//  SplashVC.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/22.
//

import UIKit
import AuthenticationServices
import CryptoKit
import FirebaseAuth

class SplashVC: UIViewController {
    
    private let userIdKey = "toPetherKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = UserDefaults.standard.string(forKey: userIdKey) else {
            // No user id was found, Show SignInWithApple
            tapLoginButton()
            return
        }
        
        // loading animation on
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: id) { [weak self] (credentialState, error) in
            guard let self = self else { return }
            
            switch credentialState {
                
            case .authorized: // The Apple ID credential is valid.
                MemberModel.shared.queryCurrentUser(id: id, completion: self.loginHandler)
                
            case .revoked: // The Apple is unvalid, maybe user signed out
                self.tapLoginButton()
                
            case .notFound: // No credential was found.
                self.tapLoginButton()
                
            default:
                self.tapLoginButton()
            }
        }
        
        setupSignInButton()

    }
    
    func setupSignInButton() {
        let button = ASAuthorizationAppleIDButton(type: .default, style: .black)
        button.center = view.center
        button.addTarget(self, action: #selector(tapLoginButton), for: .touchUpInside)
        view.addSubview(button)
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
            gotoTabbarVC()
        case .failure(let error):
            print("loginHandler", error)
            // Response the error to USER
            break
        }
    }
    
    private func gotoTabbarVC() {
        // HomePage
        let homeViewController = HomeViewController()
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        homeNavigationController.tabBarItem = UITabBarItem(title: "Home", image: Img.iconsHomeNormal.obj, selectedImage: Img.iconsHomeSelected.obj)
        
        // ToDoPage
        let toDoViewController = ToDoViewController()
        let toDoNavigationController = UINavigationController(rootViewController: toDoViewController)
        toDoNavigationController.tabBarItem = UITabBarItem(title: "To-Do", image: Img.iconsTodoNormal.obj, selectedImage: Img.iconsTodoSelected.obj)
        
        // ProfilePage
        let profileViewController = ProfileViewController()
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        profileNavigationController.tabBarItem = UITabBarItem(title: "Profile", image: Img.iconsProfileNormal.obj, selectedImage: Img.iconsProfileSelected.obj)

        let tabBarViewController = UITabBarController()
        tabBarViewController.setViewControllers([homeNavigationController, toDoNavigationController, profileNavigationController], animated: false)
        tabBarViewController.tabBar.tintColor = .mainBlue
        tabBarViewController.tabBar.unselectedItemTintColor = .deepBlueGrey
        
        UIApplication.shared.keyWindow?.rootViewController = tabBarViewController
    }
}

extension SplashVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken).")
                return
            }

            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { [weak self] (authDataResult, error) in
                guard let self = self else { return }
                if let user = authDataResult?.user {
                    print("Nice! You're now signed in as \(user.uid), email: \(user.email ?? "unknown")") // User is signed in to Firebase with Apple
                    UserDefaults.standard.set(user.uid, forKey: self.userIdKey)
                    MemberModel.shared.setMember(UID: user.uid, completion: self.loginHandler)
                    
                } else if let error = error {
                    print("sign in error:", error.localizedDescription)
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        switch (error) {
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

extension SplashVC: ASAuthorizationControllerPresentationContextProviding {
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
