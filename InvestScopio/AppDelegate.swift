//
//  AppDelegate.swift
//  InvestScopio
//
//  Created by joaoGMPereira on 05/12/2019.
//  Copyright (c) 2019 joaoGMPereira. All rights reserved.
//

import UIKit
import CryptoSwift
import JewFeatures
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarController = UITabBarController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        JEWUIColor.default.defaultColor = UIColor(named: "accent")!
        JEWUIColor.default.lightDefaultColor = UIColor(named: "accentLight")!
        JEWUIColor.default.darkDefaultColor = UIColor(named: "accentDark")!
        JEWUIColor.default.backgroundColor = UIColor.systemBackground
        UINavigationBar.appearance().tintColor = .JEWDefault()
        UISwitch.appearance().onTintColor = .JEWDefault()
        UITextField.appearance().tintColor = .JEWDefault()
        setupFirebase()
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration",
        sessionRole: connectingSceneSession.role)
    }
    
    func setupFirebase() {
        if Session.session.isDev() {
            let filePath = Bundle.main.path(forResource: "GoogleServiceInfoDev", ofType: "plist")
            guard let fileopts = FirebaseOptions(contentsOfFile: filePath!)
                else { return }
            FirebaseApp.configure(options: fileopts)
        } else {
            let filePath = Bundle.main.path(forResource: "GoogleServiceInfoProd", ofType: "plist")
            guard let fileopts = FirebaseOptions(contentsOfFile: filePath!)
                else { return }
            FirebaseApp.configure(options: fileopts)
        }
    }
    
    static func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

}

