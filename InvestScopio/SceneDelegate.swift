//
//  SceneDelegate.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 17/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import EnvironmentOverrides
import Charts

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let reachability = Reachability()
    let appSettings = AppSettings()
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            WorkingAroundSUI.setupWorkingArounds()
            
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView:
                AppRouterView().environmentObject(appSettings).environmentObject(reachability)
            )
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
