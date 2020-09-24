//
//  StartService.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 23/09/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import SwiftUI
import JewFeatures

protocol StartServiceProtocol {
    func load(userLoadable: LoadableSubject<HTTPResponse<SessionTokenModel>>, email: String, password: String)
}

struct StartService: StartServiceProtocol {
    
    let webRepository: LoginWebRepositoryProtocol
    
    init(webRepository: LoginWebRepositoryProtocol) {
        self.webRepository = webRepository
    }
    
    func load(userLoadable: LoadableSubject<HTTPResponse<SessionTokenModel>>, email: String, password: String) {
        let cancelBag = CancelBag()
        userLoadable.wrappedValue = .isLoading(last: userLoadable.wrappedValue.value, cancelBag: cancelBag)
        self.webRepository
            .login(request: UserRequest(email: email, uid: password))
            .sinkToLoadable { response in
                guard let value = response.value else {
                    JEWSession.session.services.publicKey = String()
                    JEWSession.session.services.token = String()
                    JEWSession.session.services.sessionToken = String()
                    userLoadable.wrappedValue = .failed(APIError.default)
                    return
                }
                userLoadable.wrappedValue = .loaded(value)
                JEWSession.session.services.sessionToken = value.data.sessionToken
        }
        .store(in: cancelBag)
    }
}

struct StubStartService: StartServiceProtocol {
    func load(userLoadable: LoadableSubject<HTTPResponse<SessionTokenModel>>, email: String, password: String) {
        
    }
}
