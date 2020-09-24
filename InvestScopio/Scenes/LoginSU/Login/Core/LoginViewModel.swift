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
    @Published var messageError = String()
    @Published var showLoading = false
    
    let loginService: LoginServiceProtocol
    var email = String()
    var password = String()
    var saveData = false
    var completion: (() -> Void)?
    var failure: ((AppPopupSettings) -> Void)?
    
    init(service: LoginServiceProtocol) {
        self._loginLoadable = .init(initialValue: .notRequested)
        self.loginService = service
    }
    
    func checkUserSavedEmail() {
        if let email = INVSKeyChainWrapper.retrieve(withKey: INVSConstants.LoginKeyChainConstants.lastLoginEmail.rawValue), let emailDecrypted = INVSCrypto.decryptAES(withText: email) {
                self.email = emailDecrypted
        }
        if let enableAuthentication =
            INVSKeyChainWrapper.retrieveBool(withKey: INVSConstants.LoginKeyChainConstants.hasEnableBiometricAuthentication.rawValue) {
            saveData = enableAuthentication
        }
    }
    
    func rememberUser() {
        INVSKeyChainWrapper.saveBool(withValue: saveData, andKey: INVSConstants.LoginKeyChainConstants.hasEnableBiometricAuthentication.rawValue)
        INVSKeyChainWrapper.updateBool(withValue: true, andKey: INVSConstants.LoginKeyChainConstants.hasUserLogged.rawValue)
        if let emailAES = INVSCrypto.encryptAES(withText: email), let uid = JEWSession.session.user?.uid, let securityAES = INVSCrypto.encryptAES(withText: uid) {
            INVSKeyChainWrapper.save(withValue: emailAES, andKey: INVSConstants.LoginKeyChainConstants.lastLoginEmail.rawValue)
            INVSKeyChainWrapper.save(withValue: securityAES, andKey: INVSConstants.LoginKeyChainConstants.lastLoginSecurity.rawValue)
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
    
    func hasRequiredFields() -> Bool {
        if email.isEmpty || password.isEmpty {
            loginLoadable = .failed(APIError.customError("Por favor digite email e senha para prosseguir."))
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
            INVSBiometricsChallenge.checkLoggedUser(reason: "Cadastramento da sua digital") { [self] in
                completion?()
            } failureChallenge: { [self] (type) in
                switch type {
                case .default, .error(_):
                    loginLoadable = .failed(APIError.customError("Não foi possível realizar o cadastro da biometria, tente novamente."))
                    build(state: loginLoadable)
                    
                case .goSettings(_):
                    completion?()
                }
                showLoading = false
            }
        } else {
            INVSKeyChainWrapper.clear()
            completion?()
        }
    }
}
