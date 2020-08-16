//
//  LoginViewModel.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 18/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI
import JewFeatures

class LoginViewModel: ObservableObject {
    @Published var loginLoadable: Loadable<HTTPResponse<SessionTokenModel>> {
        didSet {
            build(state: loginLoadable)
        }
    }
    @Published var showError = false
    @Published var messageError = String()
    @Published var showLoading = false
    @Published var showSimulations = false
    
    let loginService: LoginServiceProtocol
    var email = String()
    var password = String()
    var saveData = false
    
    init(service: LoginServiceProtocol) {
        self._loginLoadable = .init(initialValue: .notRequested)
        self.loginService = service
    }
    
    func checkUserSavedEmail() {
        if let email = INVSKeyChainWrapper.retrieve(withKey: INVSConstants.LoginKeyChainConstants.lastLoginEmail.rawValue), let emailDecrypted = INVSCrypto.decryptAES(withText: email) {
            //DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.email = emailDecrypted
           // }
        }
        if let enableAuthentication =
            INVSKeyChainWrapper.retrieveBool(withKey: INVSConstants.LoginKeyChainConstants.hasEnableBiometricAuthentication.rawValue) {
            saveData = enableAuthentication
        }
    }
    
    func rememberUser() {
        INVSKeyChainWrapper.saveBool(withValue: saveData, andKey: INVSConstants.LoginKeyChainConstants.hasEnableBiometricAuthentication.rawValue)
        INVSKeyChainWrapper.updateBool(withValue: true, andKey: INVSConstants.LoginKeyChainConstants.hasUserLogged.rawValue)
        if let emailAES = INVSCrypto.encryptAES(withText: email), let securityAES = INVSCrypto.encryptAES(withText: password) {
            INVSKeyChainWrapper.save(withValue: emailAES, andKey: INVSConstants.LoginKeyChainConstants.lastLoginEmail.rawValue)
            INVSKeyChainWrapper.save(withValue: securityAES, andKey: INVSConstants.LoginKeyChainConstants.lastLoginSecurity.rawValue)
        }
    }
    
    func login() {
        if hasRequiredFields() {
            switch loginLoadable {
            case .notRequested, .loaded(_), .failed(_):
                loginService
                    .load(userLoadable: loadableSubject(\.loginLoadable), email: email, password: password)
                
            case .isLoading(_, _): break
            }
        }
    }
    
    func hasRequiredFields() -> Bool {
        if email.isEmpty || password.isEmpty {
            loginLoadable = .failed(APIError.customError("Atenção!\nPor favor digite email e senha para prosseguir."))
            build(state: loginLoadable)
            return false
        }
        return true
    }
    
    func build(state: Loadable<HTTPResponse<SessionTokenModel>>) {
        switch state {
        case .notRequested:
            break
            
        case .isLoading(_, _):
            self.showError = false
            self.showLoading = true
            //Show Loading
            break
        case .loaded(_):
            self.messageError = "Autenticado com sucesso!"
            self.showSimulations = true
            self.showError = false
            self.showLoading = false
            if saveData {
                rememberUser()
            } else {
                INVSKeyChainWrapper.clear()
            }
            
        case .failed(let error):
            if let apiError = error as? APIError {
                self.messageError = apiError.errorDescription ?? String()
                self.showError = true
            }
            self.showLoading = false
            break
        }
    }
}
