//
//  INVSRouter.swift
//  InvestScopio_Example
//
//  Created by Joao Medeiros Pereira on 16/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

protocol INVSRoutingLogic {
    func routeToSimulator()
    func routeToSimulated(withViewController viewController: UIViewController, fromButton button: UIButton, andSimulatorModel simulatorModel: INVSSimulatorModel, heroId: String)
    func showNextViewController(withNewController newController: UIViewController, withOldController oldController: UIViewController, andParentViewController parentViewController: UIViewController, withAnimation animation: UIView.AnimationOptions, completion:@escaping (Bool) -> Void)
    func routeToLogin()
}


class INVSRouter: NSObject, INVSRoutingLogic {
    func routeToSimulator() {
    }
    
    func routeToLogin() {
        Session.session.user = nil
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        let loginViewController = INVSLoginViewController()
        var options = UIWindow.TransitionOptions()
        options.direction = .toTop
        options.duration = 0.4
        options.style = .easeOut
        options.background = UIWindow.TransitionOptions.Background.solidColor(.INVSLightGray())
        window.setRootViewController(loginViewController, options: options)
        AppDelegate.appDelegate().tabBarController.selectedIndex = 0
    }
    
    func routeToSimulated(withViewController viewController: UIViewController, fromButton button: UIButton, andSimulatorModel simulatorModel: INVSSimulatorModel, heroId: String) {
    }
    
    func showNextViewController(withNewController newController: UIViewController, withOldController oldController: UIViewController, andParentViewController parentViewController: UIViewController, withAnimation animation: UIView.AnimationOptions, completion:@escaping (Bool) -> Void) {
        
        oldController.willMove(toParent: nil)
        parentViewController.addChild(newController)
        newController.view.frame = oldController.view.frame
        
        parentViewController.transition(from: oldController, to: newController, duration: 0.5, options: animation, animations: {
            // nothing needed here
        }, completion: { _ -> Void in
            oldController.removeFromParent()
            newController.didMove(toParent: parentViewController)
            completion(true)
        })
    }
}
