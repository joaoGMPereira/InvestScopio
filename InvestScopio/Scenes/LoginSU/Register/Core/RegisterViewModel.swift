//
//  RegisterViewModel.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 20/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import SwiftUI
import JewFeatures

class RegisterViewModel: ObservableObject {
    
    @Published var user = INVSUserModel(email: "", uid: "")
    @Published var registerLoadable: Loadable<HTTPResponse<JEWUserResponse>> {
        didSet {
            build(state: registerLoadable)
        }
    }
    @Published var showLoading = false
    @Published var showSuccess = false
    @Published var close = true {
        didSet {
            email = String()
            password = String()
            confirmationPassword = String()
        }
    }
    @Published var messageError = String()
    @Published var messageSuccess = String()

    let registerService: RegisterServiceProtocol
    var email = String()
    var password = String()
    var confirmationPassword = String()
    var completion: (() -> Void)?
    var failure:((AppPopupSettings) -> Void)?
    
    init(service: RegisterServiceProtocol) {
        self._registerLoadable = .init(initialValue: .notRequested)
        self.registerService = service
    }
    
    func register(completion: @escaping () -> Void, failure: @escaping (AppPopupSettings) -> Void) {
        self.completion = completion
        self.failure = failure
        if hasRequiredFields() {
            switch registerLoadable {
            case .notRequested, .loaded(_), .failed(_):
                registerService
                    .load(register: loadableSubject(\.registerLoadable), email: email, password: password)
                
            case .isLoading(_, _): break
                //aguarde um momento
            }
        }
    }
    
    func hasRequiredFields() -> Bool {
        if email.isEmpty || password.isEmpty || confirmationPassword.isEmpty {
            registerLoadable = .failed(APIError.customError("Atenção!\nPreencha todos os campos para fazer o cadastro."))
            build(state: registerLoadable)
            return false
        }
        if password != confirmationPassword {
            registerLoadable = .failed(APIError.customError("Atenção!\nSenha e Confirmação não conferem, verifique novamente."))
            build(state: registerLoadable)
            return false
        }
        
        if email.isValidEmail() == false {
            registerLoadable = .failed(APIError.customError("Atenção!\n.Email inválido."))
            build(state: registerLoadable)
            return false
        }
        
        if password.count < 6 {
            registerLoadable = .failed(APIError.customError("Atenção!\nSenha deve ter pelo menos 6 digitos."))
            build(state: registerLoadable)
            return false
        }
        return true
    }
    
    func build(state: Loadable<HTTPResponse<JEWUserResponse>>) {
        switch state {
        case .notRequested:
            break
            
        case .isLoading(_, _):
            self.showLoading = true
            break
        case .loaded(let response):
            self.messageSuccess = response.message ?? String()
            self.showSuccess = true
            self.showLoading = false
            self.completion?()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.close = true
                self.showSuccess = false
            }
            
        case .failed(let error):
            if let apiError = error as? APIError {
                self.messageError = apiError.errorDescription ?? String()
                self.failure?(AppPopupSettings(message: messageError, textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true))
            }
            self.showLoading = false
            break
        }
    }
}
