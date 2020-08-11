//
//  LoginService.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 18/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Combine
import FirebaseAuth
import Foundation
import SwiftUI
import JewFeatures

protocol LoginServiceProtocol {
    func load(userLoadable: LoadableSubject<HTTPResponse<SessionTokenModel>>, email: String, password: String)
}

struct LoginService: LoginServiceProtocol {
    
    let webRepository: LoginWebRepositoryProtocol
    
    init(webRepository: LoginWebRepositoryProtocol) {
        self.webRepository = webRepository
    }
    
    func load(userLoadable: LoadableSubject<HTTPResponse<SessionTokenModel>>, email: String, password: String) {
        let cancelBag = CancelBag()
        userLoadable.wrappedValue = .isLoading(last: userLoadable.wrappedValue.value, cancelBag: cancelBag)
        self.firebaseLogin(userLoadable: userLoadable, email: email.lowercased(), password: password) { (userModel) in
            JEWSession.session.user = userModel
            self.webRepository
                .login(request: UserRequest(email: userModel.email, uid: userModel.uid, fullName: userModel.fullName, photoURL: userModel.photoURL))
                .sinkToLoadable { response in
                    guard let value = response.value else {
                        JEWSession.session.services.publicKey = String()
                        JEWSession.session.services.token = String()
                        JEWSession.session.services.sessionToken = String()
                        userLoadable.wrappedValue = .failed(APIError.customError("Atenção!\nDesculpe, tivemos algum problema, tente novamente mais tarde!"))
                        return
                    }
                    userLoadable.wrappedValue = .loaded(value)
                    JEWSession.session.services.sessionToken = value.data.sessionToken
            }
            .store(in: cancelBag)
        }
    }
    
    private func firebaseLogin(userLoadable: LoadableSubject<HTTPResponse<SessionTokenModel>>, email: String, password: String, successCompletion: @escaping (JEWUserModel) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            guard let user = result?.user else {
                userLoadable.wrappedValue = .failed(APIError.customError("Atenção!\nDados inválidos, tente novamente."))
                return
            }
            successCompletion(JEWUserModel(email: user.email, uid: user.uid, fullName: user.displayName, photoURL: user.photoURL))
        }
    }
    
}

struct StubLoginService: LoginServiceProtocol {
    
    func load(userLoadable: LoadableSubject<HTTPResponse<SessionTokenModel>>, email: String, password: String) {
        
    }
}
