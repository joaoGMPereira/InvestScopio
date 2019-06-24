//
//  INVSConnectorHelpers.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 22/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import UIKit

enum ConnectorRoutes {
    case signup
    case signin
    case logout
    case simulation
    case refreshToken
    
    func getRoute() -> URL? {
        switch self {
        case .signup:
            return INVSConector.getURL(withRoute: "/account/sign-up")
        case .signin:
            return INVSConector.getURL(withRoute: "/account/sign-in")
        case .logout:
            return INVSConector.getURL(withRoute: "/account/logout")
        case .simulation:
            return INVSConector.getURL(withRoute: "/simulation/values")
        case .refreshToken:
            return INVSConector.getURL(withRoute: "/account/refresh-token")
        }
    }
}

enum ConnectorError: Error {
    case parseError
    
    static func checkErrorCode(_ connectorError: ConnectorError) -> DefaultError {
        switch connectorError {
        case .parseError:
            return DefaultError.default()
        }
    }
}

struct DefaultError: Decodable {
    var error: Bool = true
    let reason: String
    
    static func `default`() -> DefaultError {
        return DefaultError(error: true, reason: INVSFloatingTextFieldType.defaultErrorMessage())
    }
}

class INVSConnectorHelpers: NSObject {
    static func presentErrorRememberedUserLogged(lastViewController: UIViewController? = nil) {
        guard let lastViewController = lastViewController else {
            goToLogin()
            return
        }
        let errorViewController = INVSAlertViewController()
        errorViewController.setup(withHeight: 150, andWidth: 300, andCornerRadius: 8, andContentViewColor: .white)
        errorViewController.titleAlert = INVSConstants.RefreshErrors.title.rawValue
        errorViewController.messageAlert = INVSConstants.RefreshErrors.message.rawValue
        errorViewController.hasCancelButton = false
        errorViewController.view.frame = lastViewController.view.bounds
        errorViewController.modalPresentationStyle = .overCurrentContext
        errorViewController.view.backgroundColor = .clear
        lastViewController.present(errorViewController, animated: true, completion: nil)
        errorViewController.confirmCallback = { (button) -> () in
            errorViewController.dismiss(animated: true) {
                lastViewController.dismiss(animated: false, completion: nil)
                    goToLogin()
                }
            }
        }
    
    static func presentErrorRememberedUserLogged(lastViewController: UIViewController? = nil, error: AuthenticationError, successCompletion: @escaping(SuccessVoidResponse)) {
        guard let lastViewController = lastViewController else {
            goToLogin()
            return
        }
        let errorViewController = INVSAlertViewController()
        errorViewController.setup(withHeight: 150, andWidth: 300, andCornerRadius: 8, andContentViewColor: .white)
        errorViewController.titleAlert = error.title()
        errorViewController.messageAlert = error.message()
        errorViewController.hasCancelButton = false
        errorViewController.view.frame = lastViewController.view.bounds
        errorViewController.modalPresentationStyle = .overCurrentContext
        errorViewController.view.backgroundColor = .clear
        lastViewController.present(errorViewController, animated: true, completion: nil)
        errorViewController.confirmCallback = { (button) -> () in
            errorViewController.dismiss(animated: true) {
                if error.shouldRetry() == true  {
                    INVSConector.connector.checkLoggedUser {
                        successCompletion()
                    }
                } else {
                    lastViewController.dismiss(animated: false, completion: nil)
                    goToLogin()
                }
            }
        }
    }
    
    static func presentErrorGoToSettingsRememberedUserLogged(lastViewController: UIViewController? = nil, message: String, title: String = INVSConstants.StartAlertViewController.title.rawValue) {
        guard let lastViewController = lastViewController else {
            goToLogin()
            return
        }
        let errorViewController = INVSAlertViewController()
        errorViewController.setup(withHeight: 150, andWidth: 300, andCornerRadius: 8, andContentViewColor: .white)
        errorViewController.titleAlert = INVSConstants.StartAlertViewController.titleSettings.rawValue
        errorViewController.messageAlert = message
        errorViewController.hasCancelButton = false
        errorViewController.view.frame = lastViewController.view.bounds
        errorViewController.modalPresentationStyle = .overCurrentContext
        errorViewController.view.backgroundColor = .clear
        lastViewController.present(errorViewController, animated: true, completion: nil)
        errorViewController.confirmCallback = { (button) -> () in
            errorViewController.dismiss(animated: true) {
                let url = URL(string: "App-Prefs:root=TOUCHID_PASSCODE")
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                }
                lastViewController.dismiss(animated: false, completion: nil)
                self.goToLogin()
            }
        }
    }
    
    static func goToLogin() {
        let router = INVSRouter()
        router.routeToLogin()
    }
}
