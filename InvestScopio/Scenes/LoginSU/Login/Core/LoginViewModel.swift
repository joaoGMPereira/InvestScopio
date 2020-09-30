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
    @Published var loginAdminLoadable: Loadable<HTTPResponse<SessionTokenModel>> {
        didSet {
            buildAdmin(state: loginAdminLoadable)
        }
    }
    @Published var messageError = String()
    @Published var showLoading = false
    @Published var adminClose = true
    @Published var adminLoading = false
    
    let loginService: LoginServiceProtocol
    var email = String()
    var password = String()
    var saveData = false
    var completion: (() -> Void)?
    var failure: ((AppPopupSettings) -> Void)?
    
    init(service: LoginServiceProtocol) {
        self._loginLoadable = .init(initialValue: .notRequested)
        self._loginAdminLoadable = .init(initialValue: .notRequested)
        self.loginService = service
    }
    
    func checkUserSavedEmail() {
        if let email = JEWKeyChainWrapper.retrieve(withKey: JEWConstants.LoginKeyChainConstants.lastLoginEmail.rawValue), let emailDecrypted = LocalCrypto.decryptAES(withText: email) {
            self.email = emailDecrypted
        }
        if let enableAuthentication =
            JEWKeyChainWrapper.retrieveBool(withKey: JEWConstants.LoginKeyChainConstants.hasEnableBiometricAuthentication.rawValue) {
            saveData = enableAuthentication
        }
    }
    
    func rememberUser() {
        JEWKeyChainWrapper.saveBool(withValue: saveData, andKey: JEWConstants.LoginKeyChainConstants.hasEnableBiometricAuthentication.rawValue)
        JEWKeyChainWrapper.updateBool(withValue: true, andKey: JEWConstants.LoginKeyChainConstants.hasUserLogged.rawValue)
        if let emailAES = LocalCrypto.encryptAES(withText: email), let uid = JEWSession.session.user?.uid, let securityAES = LocalCrypto.encryptAES(withText: uid) {
            JEWKeyChainWrapper.save(withValue: emailAES, andKey: JEWConstants.LoginKeyChainConstants.lastLoginEmail.rawValue)
            JEWKeyChainWrapper.save(withValue: securityAES, andKey: JEWConstants.LoginKeyChainConstants.lastLoginSecurity.rawValue)
        }
    }
    
    func login(completion: @escaping () -> Void, failure: @escaping (AppPopupSettings) -> Void) {
        self.completion = completion
        self.failure = failure
        if hasRequiredFields() {
            switch loginLoadable {
            case .notRequested, .loaded(_), .failed(_):
                loginService
                    .load(userLoadable: loadableSubject(\.loginLoadable), email: email, password: password)
                
            case .isLoading(_, _): break
            }
        }
    }
    
    func loginAdmin(completion: @escaping () -> Void, failure: @escaping (AppPopupSettings) -> Void) {
        self.completion = completion
        self.failure = failure
        switch loginLoadable {
        case .notRequested, .loaded(_), .failed(_):
            loginService
                .load(userLoadable: loadableSubject(\.loginAdminLoadable), email: "admin@investscopio.com.br", password: "Investscopio@123456")
            
        case .isLoading(_, _): break
        }
    }
    
    func hasRequiredFields() -> Bool {
        if email.isEmpty || password.isEmpty {
            loginLoadable = .failed(APIError.customError("Por favor digite email e senha para prosseguir."))
            build(state: loginLoadable)
            return false
        }
        return true
    }
    
    func buildAdmin(state: Loadable<HTTPResponse<SessionTokenModel>>) {
        switch state {
        case .notRequested:
            break
            
        case .isLoading(_, _):
            self.adminLoading = true
            break
        case .loaded(_):
            self.adminLoading = false
            self.adminClose = true
            loginWithCleanInfo()
        case .failed(let error):
            if let apiError = error as? APIError {
                self.messageError = apiError.errorDescription ?? String()
                self.failure?(AppPopupSettings(message: messageError, textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true))
            }
            self.adminLoading = false
            break
        }
    }
    
    func build(state: Loadable<HTTPResponse<SessionTokenModel>>) {
        switch state {
        case .notRequested:
            break
            
        case .isLoading(_, _):
            self.showLoading = true
            break
        case .loaded(_):
            validateLogin()
        case .failed(let error):
            if let apiError = error as? APIError {
                self.messageError = apiError.errorDescription ?? String()
                self.failure?(AppPopupSettings(message: messageError, textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true))
            }
            self.showLoading = false
            break
        }
    }
    
    func validateLogin() {
        self.showLoading = false
        rememberUser()
        if saveData {
            JEWBiometricsChallenge.checkLoggedUser(reason: "Cadastramento da sua digital") { [self] in
                completion?()
                self.password = String()
            } failureChallenge: { [self] (type) in
                switch type {
                case .default, .error(_):
                    loginLoadable = .failed(APIError.customError("Não foi possível realizar o cadastro da biometria, tente novamente."))
                    build(state: loginLoadable)
                    
                case .goSettings(_):
                    completion?()
                    self.password = String()
                }
                showLoading = false
            }
        } else {
            loginWithCleanInfo()
        }
    }
    
    func loginWithCleanInfo() {
        JEWKeyChainWrapper.clear()
        completion?()
        email = String()
        password = String()
    }
}
