//
//  PrivacyPolicyViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/11.
//

import UIKit
import WebKit
import Lottie

class PrivacyPolicyViewController: UIViewController {

    private let loadingAnimationView = AnimationView.init(name: "lottieLoading")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let privacyPolicyURL = "https://www.privacypolicies.com/live/ee7f5a2b-33d3-4b00-bf9b-32d784f8cb81"
        loadURL(urlString: privacyPolicyURL)
    }
    
    private func loadURL(urlString: String) {
        let url = URL(string: urlString)
        if let url = url {
            let request = URLRequest(url: url)
            let webView = WKWebView()
            webView.navigationDelegate = self
            webView.load(request)
            webView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(webView)
            view.sendSubviewToBack(webView)
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    }
}

extension PrivacyPolicyViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        loadingAnimationView.contentMode = .scaleAspectFit
        loadingAnimationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingAnimationView)
        NSLayoutConstraint.activate([
            loadingAnimationView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loadingAnimationView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            loadingAnimationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            loadingAnimationView.heightAnchor.constraint(equalTo: loadingAnimationView.widthAnchor)
        ])
     
        loadingAnimationView.loopMode = .loop
        loadingAnimationView.play(completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        loadingAnimationView.stop()
        loadingAnimationView.isHidden = true
    }
}