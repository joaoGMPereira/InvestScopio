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
    
    func downloadMarketInfo() {
        worker.downloadMarketInfo(successCompletionHandler: { (market) in
            self.presenter?.presentMarketInfo(withMarket: market)
        }) { (error) in
            self.presenter?.presentMarketError(withMarketError: error)
        }
    }
    
    func checkLoggedUser() {
        INVSBiometricsChallenge.checkLoggedUser(successChallenge: {
            self.loginUserSaved()
        }) { (challengeFailureType) in
            switch challengeFailureType {
            case .default:
                self.presenter?.presentErrorRememberedUserLogged()
                break
            case .error(let error):
                self.presenter?.presentErrorRememberedUserLogged(withError: error)
                break
            case .goSettings(let error):
                self.presenter?.presentErrorGoToSettingsRememberedUserLogged(withMessage: error.message())
                break
            }
        }
    }
    
    func loginUserSaved() {
        let email = INVSKeyChainWrapper.retrieve(withKey: INVSConstants.LoginKeyChainConstants.lastLoginEmail.rawValue)
        let security = INVSKeyChainWrapper.retrieve(withKey: INVSConstants.LoginKeyChainConstants.lastLoginSecurity.rawValue)
        if let emailRetrived = email, let securityRetrived = security {
            if let emailAES = INVSCrypto.decryptAES(withText: emailRetrived), let securityAES = INVSCrypto.decryptAES(withText: securityRetrived) {
                workerLogin.loggedUser(withEmail: emailAES, security: securityAES, successCompletionHandler: { (userResponse) in
                    Session.session.user = userResponse
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
}
