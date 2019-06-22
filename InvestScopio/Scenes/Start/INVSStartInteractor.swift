//
//  INVSSMarketInteractor.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 29/05/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import UIKit
protocol INVSStartInteractorProtocol {
    func checkLoggedUser()
    func downloadMarketInfo()
}

class INVSStartInteractor: NSObject, INVSStartInteractorProtocol {
    
    var presenter: INVSStartPresenterProtocol?
    var worker: INVSStartWorkerProtocol = INVSStartWorker()
    var workerLogin: INVSLoginWorkerProtocol = INVSLoginWorker()
    
    func checkLoggedUser() {
        let hasBiometricAuthenticationEnabled = INVSKeyChainWrapper.retrieveBool(withKey: INVSConstants.LoginKeyChainConstants.hasEnableBiometricAuthentication.rawValue)
        if let hasBiometricAuthentication = hasBiometricAuthenticationEnabled, hasBiometricAuthentication == true {
            showTouchId()
        } else {
            self.presenter?.presentErrorRememberedUserLogged()
        }
    }
    
    func downloadMarketInfo() {
        worker.downloadMarketInfo(successCompletionHandler: { (market) in
            self.presenter?.presentMarketInfo(withMarket: market)
        }) { (error) in
            self.presenter?.presentMarketError(withMarketError: error)
        }
    }
    
    func loginUserSaved() {
        let email = INVSKeyChainWrapper.retrieve(withKey: INVSConstants.LoginKeyChainConstants.lastLoginEmail.rawValue)
        let security = INVSKeyChainWrapper.retrieve(withKey: INVSConstants.LoginKeyChainConstants.lastLoginSecurity.rawValue)
        if let emailRetrived = email, let securityRetrived = security {
            if let emailAES = INVSCrypto.decryptAES(withText: emailRetrived), let securityAES = INVSCrypto.decryptAES(withText: securityRetrived) {
                workerLogin.loggedUser(withEmail: emailAES, security: securityAES, successCompletionHandler: { (userResponse) in
                    INVSSession.session.user = userResponse
                    self.presenter?.presentSuccessRememberedUserLogged()
                }) { (title, message, shouldHideAutomatically, popupType) in
                    INVSKeyChainWrapper.clear()
                    self.presenter?.presentErrorRememberedUserLogged()
                }
            } else {
                INVSKeyChainWrapper.clear()
                self.presenter?.presentErrorRememberedUserLogged()
            }
        } else {
            INVSKeyChainWrapper.clear()
            self.presenter?.presentErrorRememberedUserLogged()
        }
    }
    
    func showTouchId() {
        // start authentication
        INVSBiometrics.authenticateWithBiometrics(reason: "", success: {
            // authentication successful
            self.loginUserSaved()
        }, failure: { [weak self] (error) in
            // do nothing on canceled
            if error == .canceledByUser || error == .canceledBySystem || error == .fallback  {
                self?.presenter?.presentErrorRememberedUserLogged()
                return
            }
                // device does not support biometric (face id or touch id) authentication
            else if error == .biometryNotAvailable {
                self?.presenter?.presentErrorRememberedUserLogged(withError: error)
            }
                // No biometry enrolled in this device, ask user to register fingerprint or face
            else if error == .biometryNotEnrolled {
                self?.presenter?.presentErrorGoToSettingsRememberedUserLogged(withMessage: error.message())
            }
                // Biometry is locked out now, because there were too many failed attempts.
                // Need to enter device passcode to unlock.
            else if error == .biometryLockedout {
                self?.showPasscodeAuthentication(message: error.message())
            }
                // show error on authentication failed
            else {
                self?.presenter?.presentErrorRememberedUserLogged(withError: AuthenticationError.failed)
            }
        })
    }
    
    // show passcode authentication
    func showPasscodeAuthentication(message: String) {
        
        INVSBiometrics.authenticateWithPasscode(reason: message, success: {
            // passcode authentication success
            self.loginUserSaved()
        }) { (error) in
            self.presenter?.presentErrorRememberedUserLogged()
        }
    }
}
