//
//  AppDelegate.swift
//  InvestScopio
//
//  Created by joaoGMPereira on 05/12/2019.
//  Copyright (c) 2019 joaoGMPereira. All rights reserved.
//

import UIKit
import Firebase
import CryptoSwift
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarController = UITabBarController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        setupFirebase()
        let startViewController = INVSStartViewController.init(nibName: INVSStartViewController.toString(), bundle: Bundle(for: INVSStartViewController.self))
        window!.rootViewController = startViewController
        window!.makeKeyAndVisible()
        
        // Override point for customization after application launch.
        return true
    }
    
    func setupFirebase() {
        if INVSSession.session.isDev() {
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
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
            tasks.forEach{ $0.cancel() }
        }
    }

}

