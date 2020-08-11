//
//  ResendPasswordViewModel.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 20/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import SwiftUI

class ResendPasswordViewModel: ObservableObject {
    
    @Published var user = INVSUserModel(email: "", uid: "")
    @Published var resendPasswordLoadable: Loadable<String> {
        didSet {
            build(state: resendPasswordLoadable)
        }
    }
    @Published var showLoading = false
    @Published var showError = false
    @Published var showSuccess = false
    @Published var close = true {
        didSet {
            email = String()
        }
    }
    @Published var messageError = String()
    @Published var messageSuccess = String()

    let resendPasswordService: ResendPasswordServiceProtocol
    var email = String()
    var hasFinished: (() -> Void)?
    
    init(service: ResendPasswordServiceProtocol) {
        self._resendPasswordLoadable = .init(initialValue: .notRequested)
        self.resendPasswordService = service
    }
    
    func resendPassword(hasFinished: @escaping () -> Void) {
        self.hasFinished = hasFinished
        if hasRequiredFields() {
            switch resendPasswordLoadable {
            case .notRequested, .loaded(_), .failed(_):
                resendPasswordService
                    .load(resendPassword: loadableSubject(\.resendPasswordLoadable), email: email)
                
            case .isLoading(_, _): break
                //aguarde um momento
            }
        }
    }
    
    func hasRequiredFields() -> Bool {
        if email.isEmpty {
            resendPasswordLoadable = .failed(APIError.customError("Atenção!\nDigite um email válido."))
            build(state: resendPasswordLoadable)
            return false
        }
        return true
    }
    
    func build(state: Loadable<String>) {
        switch state {
        case .notRequested:
            break
            
        case .isLoading(_, _):
            self.showError = false
            self.showLoading = true
            //Show Loading
            break
        case .loaded(let response):
            self.messageSuccess = response
            self.showSuccess = true
            self.showError = false
            self.showLoading = false
            self.hasFinished?()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.close = true
                self.showSuccess = false
            }
            
        case .failed(let error):
            if let apiError = error as? APIError {
                self.messageError = apiError.errorDescription ?? String()
                self.showError = true
            }
            self.showLoading = false
            //Show Alert
            break
        }
    }
}
