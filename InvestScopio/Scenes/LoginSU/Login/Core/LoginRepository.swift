//
//  LoginRepository.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 18/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Combine
import Foundation
import JewFeatures

protocol LoginWebRepositoryProtocol: WebRepository {
    func login(request: UserRequest) -> AnyPublisher<HTTPResponse<SessionTokenModel>
        , Error>
}

class LoginWebRepository: LoginWebRepositoryProtocol {
    
    func login(request: UserRequest) -> AnyPublisher<HTTPResponse<SessionTokenModel>, Error> {
        return AccessRepository.getAccess()
            .flatMap{response in self.post(loginRequest: request, accessToken: response.data.accessToken)}
            .eraseToAnyPublisher()
    }
    
    func post(loginRequest: UserRequest, accessToken: String) -> AnyPublisher<HTTPResponse<SessionTokenModel>, Error> {
        JEWSession.session.services.token = accessToken
        return call(endpoint: API.login(loginRequest))
    }
}

// MARK: - Endpoints

extension LoginWebRepository {
    enum API {
        case login(_ request: UserRequest)
    }
}

extension LoginWebRepository.API: APICall {
    var sessionToken: Bool {
        return false
    }
    var route: ConnectorRoutes {
        switch self {
        case .login:
            return .signin
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        }
    }
    
    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        switch self {
        case .login:
            headers["access-token"] = JEWSession.session.services.token
        }
        return headers
    }
    
    func body() -> HTTPRequest? {
        switch self {
        case .login(let request):
            if  let theJSONData = try? JSONSerialization.data(
                                       withJSONObject: request.toDict(),
                                       options: []), let encryptedAESCryptoString = AES256Crypter.crypto.encrypt(theJSONData) {
                return HTTPRequest(data: encryptedAESCryptoString)
            }
            return nil
        }
    }
}
