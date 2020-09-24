//
//  StartViewModel.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 23/09/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import SwiftUI
import JewFeatures

class StartViewModel: ObservableObject {
    
    @Published var user = INVSUserModel(email: "", uid: "")
    @Published var loginLoadable: Loadable<HTTPResponse<SessionTokenModel>> {
        didSet {
            build(state: loginLoadable)
        }
    }
    @Published var message = String()
    var hasRetry = false
    let startService: StartServiceProtocol
    var completion: ((_ isLoading: Bool) -> Void)?
    var failure:((AppPopupSettings, _ hasCancelled: Bool) -> Void)?
    
    init(service: StartServiceProtocol) {
        self._loginLoadable = .init(initialValue: .notRequested)
        self.startService = service
    }
    
    func authentication(completion: @escaping (_ isLoading: Bool) -> Void, failure: @escaping (AppPopupSettings, _ hasCancelled: Bool) -> Void) {
        self.completion = completion
        self.failure = failure
        INVSBiometricsChallenge.checkLoggedUser() { [self] in
            guard let email = INVSKeyChainWrapper.retrieve(withKey: INVSConstants.LoginKeyChainConstants.lastLoginEmail.rawValue), let emailDecrypted = INVSCrypto.decryptAES(withText: email), let password = INVSKeyChainWrapper.retrieve(withKey: INVSConstants.LoginKeyChainConstants.lastLoginSecurity.rawValue), let passwordDecrypted = INVSCrypto.decryptAES(withText: password) else {
                self.message = APIError.default.errorDescription ?? String()
                self.failure?(AppPopupSettings(message: message, textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true), true)
                return
            }
            startService
                .load(userLoadable: loadableSubject(\.loginLoadable), email: emailDecrypted, password: passwordDecrypted)
        } failureChallenge: { [self] (type) in
            switch type {
            case .goSettings(_):
                self.message = "Habilite a biometria do seu celular para fazer o login automático!"
                self.failure?(AppPopupSettings(message: message, textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true), true)
            case .default:
                self.message = APIError.default.errorDescription ?? String()
                self.failure?(AppPopupSettings(message: message, textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true), true)
                INVSKeyChainWrapper.clear()
            case .error(_):
                if !hasRetry {
                    hasRetry = true
                    message = "Não foi possível identificar sua biometria, tente novamente!"
                    self.failure?(AppPopupSettings(message: message, textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true), false)
                    authentication(completion: completion, failure: failure)
                return
                }
                message = "Não foi possível identificar sua biometria, faça o login novamente!"
                self.failure?(AppPopupSettings(message: message, textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true), true)
                INVSKeyChainWrapper.clear()
            }
            
            
        }
        
    }
    
    func build(state: Loadable<HTTPResponse<SessionTokenModel>>) {
        switch state {
        case .notRequested:
            break
            
        case .isLoading(_, _):
            self.completion?(true)
            break
        case .loaded(_):
            self.completion?(false)
        case .failed(let error):
            if let apiError = error as? APIError {
                self.message = apiError.errorDescription ?? String()
                self.failure?(AppPopupSettings(message: message, textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true), true)
            }
            break
        }
    }
}

