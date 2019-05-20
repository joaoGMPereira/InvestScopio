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
    func routeToSimulated(withSimulatorViewController viewController: INVSSimutatorViewControler, andSimulatedValues simulatedValues: [INVSSimulatedValueModel])
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
    
    func routeToSimulated(withSimulatorViewController viewController: INVSSimutatorViewControler, andSimulatedValues simulatedValues: [INVSSimulatedValueModel]) {
        viewController.loadingView.stopAnimating()
        viewController.saveButton.hero.id = INVSConstants.INVSTransactionsViewControllersID.startSimulatedViewController.rawValue
        
        let homeViewController = INVSSimulatedViewController()
        homeViewController.hero.isEnabled = true
        
        homeViewController.tableView.hero.id = INVSConstants.INVSTransactionsViewControllersID.startSimulatedViewController.rawValue
        homeViewController.setup(withSimulatedValues: simulatedValues)
        viewController.present(homeViewController, animated: true) {
            viewController.saveButton.setTitle("Simular", for: .normal)
        }
    }
    
    
}
