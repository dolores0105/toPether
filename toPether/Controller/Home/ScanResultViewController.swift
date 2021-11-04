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
    
    convenience init(scannedMemberId: String) {
        self.init()
        self.scannedMemberId = scannedMemberId
    }
    private var scannedMemberId: String!
    
    private var animator: UIViewPropertyAnimator!
    private var floatingView: UIView! {
        didSet {
            floatingView.layer.cornerRadius = 10
            floatingView.layer.masksToBounds = true
        }
    }
    
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
        
        let pan = UIPanGestureRecognizer(
            target: self,
            action: #selector(panOnFloatingView(_:)))
        floatingView.isUserInteractionEnabled = true
        floatingView.addGestureRecognizer(pan)
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
