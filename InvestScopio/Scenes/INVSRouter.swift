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
        guard let window = UIApplication.shared.keyWindow else {
            return
        }

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.tabBarController.tabBar.tintColor = .INVSDefault()
            var navigationControllers = [UINavigationController]()
            if INVSKeyChainWrapper.retrieveBool(withKey: INVSConstants.LoginKeyChainConstants.hasUserLogged.rawValue) == true {
                let simulationsTapImage = UIImage(named: "listIcon")
                let simulationsTabBarItem = UITabBarItem(title: "Simulacões", image: simulationsTapImage, tag: 0)
                let simulationsViewController = INVSSimulationsViewController.init(nibName: INVSSimulationsViewController.toString(), bundle: Bundle(for: INVSSimulationsViewController.self))
                simulationsViewController.tabBarItem = simulationsTabBarItem
                navigationControllers.append(UINavigationController.init(rootViewController: simulationsViewController))
            }
            let simulatorTapImage = UIImage(named: "chartIcon")
            let simulatorTabBarItem = UITabBarItem(title: "Simulador", image: simulatorTapImage, tag: navigationControllers.count)
            let simulatorViewController = INVSSimutatorViewControler.init(nibName: INVSSimutatorViewControler.toString(), bundle: Bundle(for: INVSSimutatorViewControler.self))
            simulatorViewController.tabBarItem = simulatorTabBarItem
            navigationControllers.append(UINavigationController.init(rootViewController: simulatorViewController))
            
            let talkWithUsTapImage = UIImage(named: "talkWithUsIcon")
            let talkWithUsBarItem = UITabBarItem(title: "Fale Conosco", image: talkWithUsTapImage, tag: navigationControllers.count)
            let talkWithUsViewController = INVSTalkWithUsViewController.init(nibName: INVSTalkWithUsViewController.toString(), bundle: Bundle(for: INVSTalkWithUsViewController.self))
            talkWithUsViewController.tabBarItem = talkWithUsBarItem
            navigationControllers.append(UINavigationController.init(rootViewController: talkWithUsViewController))
            appDelegate.tabBarController.setViewControllers(navigationControllers, animated: true)
            var options = UIWindow.TransitionOptions()
            options.direction = .toBottom
            options.duration = 0.4
            options.style = .easeOut
            options.background = UIWindow.TransitionOptions.Background.solidColor(.INVSLightGray())
            window.setRootViewController(appDelegate.tabBarController, options: options)
        }
    }
    
    func routeToLogin() {
        INVSSession.session.user = nil
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
    }
    
    func routeToSimulated(withViewController viewController: UIViewController, fromButton button: UIButton, andSimulatorModel simulatorModel: INVSSimulatorModel, heroId: String) {
        button.hero.id = heroId
        
        let simulatedContainerViewController = INVSSimulatedContainerViewController()
        simulatedContainerViewController.hero.isEnabled = true

        simulatedContainerViewController.containerView.hero.id = heroId
        simulatedContainerViewController.simulatedListViewController.setup(withSimulatorModel: simulatorModel)
        let buttonTitle = button.titleLabel?.text ?? ""
        button.setTitle("", for: .normal)
        viewController.present(simulatedContainerViewController, animated: true) {
            button.setTitle(buttonTitle, for: .normal)
        }
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
