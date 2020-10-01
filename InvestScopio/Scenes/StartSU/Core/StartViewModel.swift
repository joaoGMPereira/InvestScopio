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
    
    @Published var loginLoadable: Loadable<HTTPResponse<SessionTokenModel>> {
        didSet {
            build(state: loginLoadable)
        }
    }
    @Published var message = String()
    @Published var state = LottieState.stop
    var hasRetry = false
    let startService: StartServiceProtocol
    var completion: (() -> Void)?
    var failure:((AppPopupSettings, _ hasCancelled: Bool) -> Void)?
    
    init(service: StartServiceProtocol) {
        self._loginLoadable = .init(initialValue: .notRequested)
        self.startService = service
    }
    
    func authentication(completion: @escaping () -> Void, failure: @escaping (AppPopupSettings, _ hasCancelled: Bool) -> Void) {
        self.completion = completion
        self.failure = failure
        self.state = .playFrame(fromFrame: 25, toFrame: 25, loopMode: .playOnce, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                JEWBiometricsChallenge.checkLoggedUser(keychainKey: JEWConstants.LoginKeyChainConstants.hasUserLogged.rawValue) { [self] in
                    callService()
                } failureChallenge: { [self] (type) in
                    setBiometryError(type: type, completion: completion, failure: failure)
                }
            }
    }
    
    func callService() {
        guard let email = JEWKeyChainWrapper.retrieve(withKey: JEWConstants.LoginKeyChainConstants.lastLoginEmail.rawValue), let emailDecrypted = LocalCrypto.decryptAES(withText: email), let password = JEWKeyChainWrapper.retrieve(withKey: JEWConstants.LoginKeyChainConstants.lastLoginSecurity.rawValue), let passwordDecrypted = LocalCrypto.decryptAES(withText: password) else {
            self.message = APIError.default.errorDescription ?? String()
            self.failure?(AppPopupSettings(message: message, textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true), true)
            return
        }
        startService
            .load(userLoadable: loadableSubject(\.loginLoadable), email: emailDecrypted, password: passwordDecrypted)
    }
    
    func setBiometryError(type: ChallengeFailureType, completion: @escaping () -> Void, failure: @escaping (AppPopupSettings, _ hasCancelled: Bool) -> Void) {
        switch type {
        case .goSettings(let error):
            self.message = error.message()
            self.failure?(AppPopupSettings(message: message, textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true), true)
        case .default:
            self.message = APIError.default.errorDescription ?? String()
            self.failure?(AppPopupSettings(message: message, textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true), true)
            JEWKeyChainWrapper.clear()
        case .error(let error):
            if !hasRetry {
                hasRetry = true
                message = error.message()
                self.failure?(AppPopupSettings(message: message, textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true), false)
                authentication(completion: completion, failure: failure)
                return
            }
            message = "Não foi possível identificar sua biometria, faça o login novamente!"
            self.failure?(AppPopupSettings(message: message, textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true), true)
            JEWKeyChainWrapper.clear()
        }
    }
    
    func build(state: Loadable<HTTPResponse<SessionTokenModel>>) {
        switch state {
        case .notRequested:
            break
            
        case .isLoading(_, _):
            self.state = .play
            break
        case .loaded(_):
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.state = .stop
                self.completion?()
            }
        case .failed(let error):
            self.state = .playFrame(fromFrame: 25, toFrame: 25, loopMode: .playOnce, completion: nil)
            if let apiError = error as? APIError {
                self.message = apiError.errorDescription ?? String()
                self.failure?(AppPopupSettings(message: message, textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true), true)
            }
            break
        }
    }
}
