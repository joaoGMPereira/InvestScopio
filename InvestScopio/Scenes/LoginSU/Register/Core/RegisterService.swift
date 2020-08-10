//
//  RegisterService.swift
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

protocol RegisterServiceProtocol {
    func load(register: LoadableSubject<HTTPResponse<INVSSignUpModel>>, email: String, password: String)
}

struct RegisterService: RegisterServiceProtocol {
    
    let repository: RegisterRepositoryProtocol
    
    init(repository: RegisterRepositoryProtocol) {
        self.repository = repository
    }
    
    func load(register: LoadableSubject<HTTPResponse<INVSSignUpModel>>, email: String, password: String) {
        let cancelBag = CancelBag()
        register.wrappedValue = .isLoading(last: register.wrappedValue.value, cancelBag: cancelBag)
        self.firebaseRegister(register: register, email: email.lowercased(), password: password) { (userModel) in
            self.repository
                .register(user: INVSUserRequest(email: userModel.email, password: userModel.uid))
                .sinkToLoadable { response in
                    register.wrappedValue = response
            }
            .store(in: cancelBag)
        }
    }
    
    private func firebaseRegister(register: LoadableSubject<HTTPResponse<INVSSignUpModel>>, email: String, password: String, successCompletion: @escaping (INVSUserModel) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            guard let user = result?.user else {
                JEWLogger.error(error ?? "Atenção\nDados inválidos, tente novamente.")
                register.wrappedValue = .failed(APIError.customError("Atenção\nDados inválidos, tente novamente."))
                return
            }
            successCompletion(INVSUserModel(email: user.email ?? "", uid: user.uid))
        }
    }
}

struct StubRegisterService: RegisterServiceProtocol {
    func load(register: LoadableSubject<HTTPResponse<INVSSignUpModel>>, email: String, password: String) {
        
    }
}
