//
//  RegisterRepository.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 20/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Combine
import Foundation


protocol RegisterRepositoryProtocol: WebRepository {
    func register(user: INVSUserRequest) -> AnyPublisher<HTTPResponse<INVSSignUpModel>, Error>
}

struct RegisterRepository: RegisterRepositoryProtocol {
    
    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(session: URLSession? = nil, baseURL: String? = nil) {
        self.session = Self.configuredURLSession()
        self.baseURL = "https://invest-scopio-dev-backend.herokuapp.com/api/v1"
    }
    
    func register(user: INVSUserRequest) -> AnyPublisher<HTTPResponse<INVSSignUpModel>, Error> {
        return call(endpoint: API.register(user: user))
    }
}

// MARK: - Endpoints

extension RegisterRepository {
    enum API {
        case register(user: INVSUserRequest)
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
        return ["Content-Type": "application/json"]
    }
    func body() -> HTTPRequest? {
        switch self {
        case .register(user: let user):
//            if let theJSONData = try? JSONSerialization.data(
//                withJSONObject: user.toDict(),
//            options: []) {
//                return theJSONData
//            }
            return nil
        }
        return nil
    }
}
