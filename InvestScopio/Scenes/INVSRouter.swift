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
    func routeToSimulated(withSimulatorViewController viewController: INVSSimutatorViewControler, andSimulatorModel simulatorModel: INVSSimulatorModel)
}


class INVSRouter: NSObject, INVSRoutingLogic {
    func routeToSimulator() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        let simulatorViewController = INVSSimutatorViewControler.init(nibName: INVSSimutatorViewControler.toString(), bundle: Bundle(for: INVSSimutatorViewControler.self))
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.tabBarController.tabBar.tintColor = .INVSDefault()
            let tapImage = UIImage(named: "chartIcon")
            let simulatorTabBarItem = UITabBarItem(title: "Simulador", image: tapImage, tag: 0)
            simulatorViewController.tabBarItem = simulatorTabBarItem
            
            appDelegate.tabBarController.setViewControllers([UINavigationController(rootViewController: simulatorViewController)], animated: true)
            var options = UIWindow.TransitionOptions()
            options.direction = .toTop
            options.duration = 0.4
            options.style = .easeOut
            options.background = UIWindow.TransitionOptions.Background.solidColor(.INVSLightGray())
            window.setRootViewController(appDelegate.tabBarController, options: options)
        }
    }
    
    func routeToSimulated(withSimulatorViewController viewController: INVSSimutatorViewControler, andSimulatorModel simulatorModel: INVSSimulatorModel) {
        viewController.saveButton.hero.id = INVSConstants.INVSTransactionsViewControllersID.startSimulatedViewController.rawValue
        
        let simulatedContainerViewController = INVSSimulatedContainerViewController()
        simulatedContainerViewController.hero.isEnabled = true

        simulatedContainerViewController.containerView.hero.id = INVSConstants.INVSTransactionsViewControllersID.startSimulatedViewController.rawValue
        simulatedContainerViewController.simulatedListViewController.setup(withSimulatorModel: simulatorModel)
        viewController.saveButton.setTitle("", for: .normal)
        viewController.present(simulatedContainerViewController, animated: true) {
            viewController.saveButton.setTitle("Simulação", for: .normal)
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
