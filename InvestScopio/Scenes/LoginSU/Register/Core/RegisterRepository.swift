//
//  RegisterRepository.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 20/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Combine
import Foundation
import JewFeatures

protocol RegisterRepositoryProtocol: WebRepository {
    func register(user: UserRequest) -> AnyPublisher<HTTPResponse<JEWUserResponse>, Error>
}

struct RegisterRepository: RegisterRepositoryProtocol {
    
    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(session: URLSession? = nil, baseURL: String? = nil) {
        self.session = Self.configuredURLSession()
        self.baseURL = "https://invest-scopio-dev-backend.herokuapp.com/api/v1"
    }
    
    func register(user: UserRequest) -> AnyPublisher<HTTPResponse<JEWUserResponse>, Error> {
        return AccessRepository.getAccess()
            .flatMap({ (response) -> AnyPublisher<HTTPResponse<JEWUserResponse>, Error> in
                JEWSession.session.services.token = response.data.accessToken
                return self.call(endpoint: API.register(user: user))
            })
            .eraseToAnyPublisher()
    }
}

// MARK: - Endpoints

extension RegisterRepository {
    enum API {
        case register(user: UserRequest)
    }
}

extension RegisterRepository.API: APICall {
    var sessionToken: Bool {
        return false
    }
    
    var route: ConnectorRoutes {
        switch self {
        case .register:
            return .signup
        }
    }
    var method: HTTPMethod {
        switch self {
        case .register:
            return .post
        }
    }
    var headers: [String: String]? {
        return ["Content-Type": "application/json", "access-token": JEWSession.session.services.token]
    }
    
    func body() -> HTTPRequest? {
        switch self {
        case .register(user: let user):
            if  let theJSONData = try? JSONSerialization.data(
                withJSONObject: user.toDict(),
                options: []), let encryptedAESCryptoString = AES256Crypter.crypto.encrypt(theJSONData) {
                return HTTPRequest(data: encryptedAESCryptoString)
            }
            return nil
        }
    }
}
