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

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let reachability = Reachability()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            WorkingAroundSUI.tableViewWorkingAround()
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: LoginView(viewModel:
                LoginViewModel(service:
                    LoginService(webRepository:
                        LoginWebRepository())
                )
                ).attachEnvironmentOverrides().environmentObject(reachability)
            )
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
}
