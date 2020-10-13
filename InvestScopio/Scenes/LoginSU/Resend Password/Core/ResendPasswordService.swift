//
//  ResendPasswordService.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 20/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import JewFeatures
import Combine
import FirebaseAuth
import Foundation
import SwiftUI

protocol ResendPasswordServiceProtocol {
    func load(resendPassword: LoadableSubject<String>, email: String)
}

struct ResendPasswordService: ResendPasswordServiceProtocol {
    
    func load(resendPassword: LoadableSubject<String>, email: String) {
        let cancelBag = CancelBag()
        resendPassword.wrappedValue = .isLoading(last: resendPassword.wrappedValue.value, cancelBag: cancelBag)
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error != nil {
                JEWLogger.error(error ?? "Não foi possível encontrar o email para recuperar senha.")
                resendPassword.wrappedValue = .failed(APIError.customError("Atenção\nNão foi possível encontrar o email para recuperar senha."))
                return
            }
            resendPassword.wrappedValue = .loaded("Atenção\nA recuperação de senha foi enviada para seu email.")
        }
    }
}

struct StubResendPasswordService: ResendPasswordServiceProtocol {
    func load(resendPassword: LoadableSubject<String>, email: String) {
        
    }
}
