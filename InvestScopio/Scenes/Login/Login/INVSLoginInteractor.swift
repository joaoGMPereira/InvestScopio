//
//  LoginInteractor.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 12/06/19.
//  Copyright (c) 2019 Joao Medeiros Pereira. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol INVSLoginInteractorProtocol {
    func checkToolbarAction(withTextField textField: INVSFloatingTextField, typeOfAction type: INVSKeyboardToolbarButton)
    func logIn(rememberMe: Bool)
    var allTextFields: [INVSFloatingTextField] { get }
}

class INVSLoginInteractor: INVSLoginInteractorProtocol {
    
    var presenter: INVSLoginPresenterProtocol?
    var worker: INVSLoginWorkerProtocol = INVSLoginWorker()
    var allTextFields = [INVSFloatingTextField]()
  // MARK: Do something
  
    func checkToolbarAction(withTextField textField: INVSFloatingTextField, typeOfAction type: INVSKeyboardToolbarButton) {
        presenter?.presentToolbarAction(withPreviousTextField: textField, allTextFields: allTextFields, typeOfAction: type)
    }
    func logIn(rememberMe: Bool) {
        worker.login(withTextFields: allTextFields, successCompletionHandler: { (userResponse) in
            INVSSession.session.user = userResponse
            self.presenter?.presentSuccessSignIn()
            self.rememberUser(withRememberMe:rememberMe, email: userResponse.email, security: userResponse.uid)
        }, errorCompletionHandler: { (title, message, shouldHideAutomatically, popupType) in
            self.presenter?.presentErrorSignIn(titleError: title, messageError: message, shouldHideAutomatically: shouldHideAutomatically, popupType: popupType)
        })
    }
    
    private func rememberUser(withRememberMe rememberMe: Bool, email: String, security: String) {
        if rememberMe {
            if let emailAES = INVSCrypto.encryptAES(withText: email), let securityAES = INVSCrypto.encryptAES(withText: security) {
                INVSKeyChainWrapper.save(withValue: emailAES, andKey: INVSConstants.LoginKeyChainConstants.lastLoginEmail.rawValue)
                INVSKeyChainWrapper.save(withValue: securityAES, andKey: INVSConstants.LoginKeyChainConstants.lastLoginSecurity.rawValue)
            }
        }
    }
}
