//
//  INVSStartViewController.swift
//  InvestScopio_Example
//
//  Created by Joao Medeiros Pereira on 17/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Lottie
import Hero

class INVSStartViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    var animatedLogoView = AnimationView()
    let router = INVSRouter()
    override func viewDidLoad() {
        super.viewDidLoad()
        animateLaunchGif()
    }
    
    func animateLaunchGif() {
        view.addSubview(animatedLogoView)
        animatedLogoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animatedLogoView.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 0),
            animatedLogoView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        let starAnimation = Animation.named("animatedLogoWhite")
        animatedLogoView.animation = starAnimation
        animatedLogoView.contentMode = .scaleAspectFit
        animatedLogoView.animationSpeed = 1.0
        animatedLogoView.loopMode = .playOnce
        animatedLogoView.play { (finished) in
            self.router.routeToSimulator()
        }
    }
}
