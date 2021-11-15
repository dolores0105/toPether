//
//  LottieWraper.swift
//  toPether
//
//  Created by 林宜萱 on 2021/11/12.
//

import UIKit
import Lottie

class LottieAnimation {
    
    static let shared = LottieAnimation()

    private init() { }
    
//    var lottieAnimation: AnimationView?
    
     func createLoopAnimation(lottieName: String) -> AnimationView {
        
        let lottieAnimation = AnimationView.init(name: lottieName)
        lottieAnimation.contentMode = .scaleAspectFit
        lottieAnimation.translatesAutoresizingMaskIntoConstraints = false
        lottieAnimation.loopMode = .loop
        lottieAnimation.play(completion: nil)
        
        return lottieAnimation
    }
    
    func stopAnimation(lottieAnimation: AnimationView) {
        
        lottieAnimation.stop()
        lottieAnimation.alpha = 0
        lottieAnimation.isHidden = true
    }
}


