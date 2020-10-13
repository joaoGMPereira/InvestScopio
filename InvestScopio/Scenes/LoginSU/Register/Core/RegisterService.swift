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
    func load(register: LoadableSubject<HTTPResponse<JEWUserResponse>>, email: String, password: String)
}

struct RegisterService: RegisterServiceProtocol {
    
    let repository: RegisterRepositoryProtocol
    
    init(repository: RegisterRepositoryProtocol) {
        self.repository = repository
    }
    
    func load(register: LoadableSubject<HTTPResponse<JEWUserResponse>>, email: String, password: String) {
        let cancelBag = CancelBag()
        register.wrappedValue = .isLoading(last: register.wrappedValue.value, cancelBag: cancelBag)
        self.firebaseRegister(register: register, email: email.lowercased(), password: password) { (request) in
            self.repository
                .register(user: request)
                .sinkToLoadable { response in
                    guard (response.value != nil) else {
                        register.wrappedValue = .failed(APIError.customError("Desculpe, tivemos algum problema, tente novamente mais tarde!"))
                        return
                    }
                    register.wrappedValue = response
            }
            .store(in: cancelBag)
        }
    }
    
    private func firebaseRegister(register: LoadableSubject<HTTPResponse<JEWUserResponse>>, email: String, password: String, successCompletion: @escaping (UserRequest) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            guard let user = result?.user else {
                var firebaseError = FireBaseErrorHandler.unknown
                if let error = error {
                    firebaseError = FireBaseErrorHandler(rawValue: error._code) ?? .unknown
                }
                let message = firebaseError.getFirebaseMessage()
                JEWLogger.error(message)
                register.wrappedValue = .failed(APIError.customError(message))
                return
            }
            successCompletion(UserRequest(email: user.email, uid: user.uid, fullName: user.displayName, photoURL: user.photoURL))
        }
    }
}

struct StubRegisterService: RegisterServiceProtocol {
    func load(register: LoadableSubject<HTTPResponse<JEWUserResponse>>, email: String, password: String) {
        
    }
}
