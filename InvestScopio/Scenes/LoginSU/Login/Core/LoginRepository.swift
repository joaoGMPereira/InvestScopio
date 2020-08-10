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
    func login(request: LoginRequest) -> AnyPublisher<HTTPResponse<SessionTokenModel>
        , Error>
}

class LoginWebRepository: LoginWebRepositoryProtocol {
    
    let session: URLSession
    let bgQueue = DispatchQueue(label: "bg_parse_queue")
    var publicKeyCancellable: AnyCancellable?
    var accessTokenCancellable: AnyCancellable?
    var signinCancellable: AnyCancellable?
    
    init(session: URLSession? = nil) {
        self.session = Self.configuredURLSession()
    }
    
    func login(request: LoginRequest) -> AnyPublisher<HTTPResponse<SessionTokenModel>, Error> {
        return publicKey()
            .flatMap{_ in self.accessToken()}
            .flatMap{_ in self.signin(request: request)}
            .eraseToAnyPublisher()
    }
    
    func publicKey() -> AnyPublisher<HTTPResponse<HTTPPublicKey>, Error> {
        let publicKeyPublisher: AnyPublisher<HTTPResponse<HTTPPublicKey>, Error> = call(endpoint: API.publicKey)
        publicKeyCancellable = publicKeyPublisher.sinkToResult({ (result) in
            switch result {
            case .success(let response):
                JEWSession.session.services.publicKey = response.data.publicKey
            case .failure:
                JEWSession.session.services.publicKey = String()
                self.publicKeyCancellable?.cancel()
            }
        })
        return publicKeyPublisher
    }
    
    func accessToken() -> AnyPublisher<HTTPResponse<HTTPAccessToken>, Error> {
        let accessTokenPublisher:AnyPublisher<HTTPResponse<HTTPAccessToken>, Error> = call(endpoint: API.accessToken)
        accessTokenCancellable = accessTokenPublisher.sinkToResult({ (result) in
            switch result {
            case .success(let response):
                JEWSession.session.services.token = response.data.accessToken
            case .failure:
                JEWSession.session.services.token = String()
                 self.accessTokenCancellable?.cancel()
            }
        })
        return accessTokenPublisher
    }
    
    func signin(request: LoginRequest) -> AnyPublisher<HTTPResponse<SessionTokenModel>, Error> {
        let loginPublisher:AnyPublisher<HTTPResponse<SessionTokenModel>, Error> = call(endpoint: API.login(request))
        signinCancellable = loginPublisher.sinkToResult({ (result) in
            switch result {
            case .success(let response):
                JEWSession.session.services.sessionToken = response.data.sessionToken
            case .failure:
                JEWSession.session.services.sessionToken = String()
                self.signinCancellable?.cancel()
            }
        })
        return loginPublisher
    }
}

// MARK: - Endpoints

extension LoginWebRepository {
    enum API {
        case publicKey
        case accessToken
        case login(_ request: LoginRequest)
    }
}

extension LoginWebRepository.API: APICall {
    var sessionToken: Bool {
        return false
    }
    var route: ConnectorRoutes {
        switch self {
        case .publicKey:
            return .publicKey
        case .accessToken:
            return .accessToken
        case .login:
            return .signin
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .publicKey:
            return .get
        case .accessToken:
            return .post
        case .login:
            return .post
        }
    }
    
    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        switch self {
        case .publicKey, .accessToken: break
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
        case .publicKey:
            return nil
        case .accessToken:
            if let aesCrypto = AES256Crypter.create(), let encryptedAESCryptoString = RSACrypto.encrypt(data: aesCrypto) {
                return HTTPRequest(data: encryptedAESCryptoString)
            }
        }
        return nil
    }
}
