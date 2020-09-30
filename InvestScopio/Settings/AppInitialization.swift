//
//  WorkingAroundSUI.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 16/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import UIKit
import JewFeatures
import Firebase
struct AppInitialization {
    
    static func initialize() {
        setup(scheme: Scheme.scheme)
        setupFirebase()
        setupColors()
        tableViewWorkingAround()
        tabbarWorkingAround()
        navbarWorkingAround()
    }
    
    static func setup(scheme: Scheme) {
        JEWSession.session.services.scheme = scheme
        Scheme.setupConfig(prodURL: AppConstants.ServicesConstants.apiV1.rawValue, debugURL: AppConstants.ServicesConstants.apiV1Dev.rawValue)
        JEWLogger.logger.isDev = Scheme.scheme == .Debug
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
    
    static func setupColors() {
        JEWUIColor.default.defaultColor = UIColor(named: "accent")!
        JEWUIColor.default.lightDefaultColor = UIColor(named: "accentLight")!
        JEWUIColor.default.darkDefaultColor = UIColor(named: "accentDark")!
        JEWUIColor.default.backgroundColor = UIColor(named: "primaryBackground")!
        UINavigationBar.appearance().tintColor = .JEWDefault()
        UISwitch.appearance().onTintColor = .JEWDefault()
        UITextField.appearance().tintColor = .JEWDefault()
    }
    
    static func setupFirebase() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        if Scheme.scheme == .Debug || Scheme.scheme == .Local {
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
    
    static func tableViewWorkingAround() {
        UITableView.appearance().tableFooterView = UIView()
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().selectionStyle = .none
    }
    
    static func tabbarWorkingAround() {
        let tabbarAppearance = UITabBarAppearance()
        tabbarAppearance.configureWithOpaqueBackground()
        tabbarAppearance.backgroundColor = UIColor(named: "secondaryBackground")
        UITabBar.appearance().standardAppearance = tabbarAppearance
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
    }
    
    static func navbarWorkingAround() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = UIColor(named: "secondaryBackground")
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
}
