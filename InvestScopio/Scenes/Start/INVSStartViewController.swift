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


protocol INVSStartViewControllerProtocol: class {
    func displayMarketInfo(withMarketInfo market: MarketModel)
    func displayMarketInfoError(witMarketError error: String)
    func displaySuccessRememberedUserLogged()
    func displayErrorRememberedUserLogged()
}

class INVSStartViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    var animatedLogoView = AnimationView()
    let router = INVSRouter()
    var interactor: INVSStartInteractorProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        let interactor = INVSStartInteractor()
        self.interactor = interactor
        let presenter = INVSStartPresenter()
        presenter.controller = self
        interactor.presenter = presenter
        animateLaunchGif()
        interactor.checkLoggedUser()
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
        animatedLogoView.loopMode = .loop
        animatedLogoView.play()
    }
}

extension INVSStartViewController: INVSStartViewControllerProtocol {
    
    func displayMarketInfo(withMarketInfo market: MarketModel) {
        
    }
    
    func displayMarketInfoError(witMarketError error: String) {
        self.router.routeToSimulator()
    }
    
    func displaySuccessRememberedUserLogged() {
        animatedLogoView.stop()
        self.router.routeToSimulator()
    }
    
    func displayErrorRememberedUserLogged() {
        
        animatedLogoView.loopMode = .playOnce
        animatedLogoView.play{ (finished) in
            self.router.routeToLogin()
        }
    }
    
}
