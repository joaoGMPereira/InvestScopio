//
//  AccessAPI.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 10/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//
import Combine
import Foundation
import JewFeatures

protocol AccessRepositoryProtocol: WebRepository {
    func access() -> AnyPublisher<HTTPResponse<HTTPAccessToken>
        , Error>
}

class AccessRepository: AccessRepositoryProtocol {

    var publicKeyCancellable: AnyCancellable?
    var accessTokenCancellable: AnyCancellable?
    var signinCancellable: AnyCancellable?
    
    func access() -> AnyPublisher<HTTPResponse<HTTPAccessToken>, Error> {
        publicKey()
            .flatMap{ response in self.accessToken(publicKey: response.data.publicKey) }
            .eraseToAnyPublisher()
    }
    
    func publicKey() -> AnyPublisher<HTTPResponse<HTTPPublicKey>, Error> {
        return call(endpoint: API.publicKey)
    }
    
    func accessToken(publicKey: String) -> AnyPublisher<HTTPResponse<HTTPAccessToken>, Error> {
        JEWSession.session.services.publicKey = publicKey
        return call(endpoint: API.accessToken)
    }
    
    static func getAccess() -> AnyPublisher<HTTPResponse<HTTPAccessToken>, Error> {
        let accessRepository = AccessRepository()
        return accessRepository.access()
    }
}

extension AccessRepository {
    enum API {
        case publicKey
        case accessToken
    }
}

extension AccessRepository.API: APICall {
    var route: ConnectorRoutes {
        switch self {
        case .publicKey:
            return .publicKey
        case .accessToken:
            return .accessToken
        }
    }
    
    var method: HTTPMethod {
        switch self {
               case .publicKey:
                   return .get
               case .accessToken:
                   return .post
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    func body() -> HTTPRequest? {
        switch self {
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
