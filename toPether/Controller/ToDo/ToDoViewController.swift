//
//  ToDoViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/30.
//

import UIKit
import Lottie

class ToDoViewController: UIViewController {

    private var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        animationView = .init(name: "layingCat")
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.play(completion: nil)
        animationView.loopMode = .loop
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor)
        ])
    }

}
