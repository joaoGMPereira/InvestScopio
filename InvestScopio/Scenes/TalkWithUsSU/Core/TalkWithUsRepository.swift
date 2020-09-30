//
//  TalkWithUsRepository.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 29/09/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Combine
import Foundation
import JewFeatures

protocol TalkWithUsRepositoryProtocol: WebRepository {
    func getNPS(versionApp: String) -> AnyPublisher<HTTPResponse<NPSModel>, Error>
    func sendNPS(request: NPSModel) -> AnyPublisher<HTTPResponse<NPSModel>, Error>
}

struct TalkWithUsRepository: TalkWithUsRepositoryProtocol {
    
    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(session: URLSession? = nil, baseURL: String? = nil) {
        self.session = Self.configuredURLSession()
        self.baseURL = "https://invest-scopio-dev-backend.herokuapp.com/api/v1"
    }
    
    func getNPS(versionApp: String) -> AnyPublisher<HTTPResponse<NPSModel>, Error> {
        self.call(endpoint: API.getNPS(versionApp))
        .eraseToAnyPublisher()
    }
    
    func sendNPS(request: NPSModel) -> AnyPublisher<HTTPResponse<NPSModel>, Error> {
        self.call(endpoint: API.sendNPS(request))
        .eraseToAnyPublisher()
    }
}

// MARK: - Endpoints

extension TalkWithUsRepository {
    enum API {
        case getNPS(_ versionApp: String)
        case sendNPS(_ request: NPSModel)
    }
}

extension TalkWithUsRepository.API: APICall {
    var sessionToken: Bool {
        return false
    }
    
    var route: ConnectorRoutes {
        switch self {
        case .sendNPS:
            return .sendNPS
        case .getNPS(let versionApp):
            return .getNPS(versionApp)
        }
    }
    var method: HTTPMethod {
        switch self {
        case .sendNPS:
            return .post
        case .getNPS:
            return .get
        }
    }
    var headers: [String: String]? {
        return ["Content-Type": "application/json", "session-token": JEWSession.session.services.sessionToken]
    }
    
    func body() -> HTTPRequest? {
        switch self {
        case .sendNPS(let request):
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: request.toDict(),
                options: []), let encryptedAESCryptoString = AES256Crypter.crypto.encrypt(theJSONData) {
                return HTTPRequest(data: encryptedAESCryptoString)
            }
            return nil
        case .getNPS:
            return nil
        }
    }
}
