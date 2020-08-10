//
//  WebRepository.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 23.10.2019.
//  Copyright © 2019 Alexey Naumov. All rights reserved.
//

import Foundation
import Combine
import JewFeatures

protocol WebRepository {
    var session: URLSession { get }
    var bgQueue: DispatchQueue { get }
}

extension WebRepository {
    
    static func configuredURLSession() -> URLSession {
        //        let configuration = URLSessionConfiguration.default
        //        configuration.timeoutIntervalForRequest = 60
        //        configuration.timeoutIntervalForResource = 120
        //        configuration.waitsForConnectivity = true
        //        configuration.httpMaximumConnectionsPerHost = 5
        //        configuration.requestCachePolicy = .returnCacheDataElseLoad
        //        configuration.urlCache = .shared
        return URLSession(configuration: .default)
    }
    
    func call<Value>(endpoint: APICall, httpCodes: HTTPCodes = .success, shouldRefreshToken: Bool = false) -> AnyPublisher<HTTPResponse<Value>, Error>
        where Value: Decodable {
            do {
                let request = try endpoint.urlRequest()
                
                return session
                    .dataTaskPublisher(for: request)
                    .requestJSON(httpCodes: httpCodes)
            } catch let error {
                return Fail<HTTPResponse<Value>, Error>(error: error).eraseToAnyPublisher()
            }
    }
    
    func callRequest<Value>(endpoint: APICall, httpCodes: HTTPCodes = .success) -> AnyPublisher<HTTPResponse<Value>, Error>
        where Value: Decodable {
            do {
                let request = try endpoint.urlRequest()
                
                return session
                    .dataTaskPublisher(for: request)
                    .requestJSON(httpCodes: httpCodes)
            } catch let error {
                return Fail<HTTPResponse<Value>, Error>(error: error).eraseToAnyPublisher()
            }
    }
    
    //    private func refreshToken(withRoute route:ConnectorRoutes, shouldRefreshToken: Bool) -> AnyPublisher<Bool, Error> {
    //        if shouldRefreshToken == false {
    //            return Just.withErrorType(true, Error.self)
    //        }
    //        guard let headers = ["Content-Type": "application/json", "Authorization": Session.session.user?.access?.accessToken] as? [String: String], let refreshToken = Session.session.user?.access?.refreshToken else {
    //            return Fail<Bool, Error>(error: APIError.logout).eraseToAnyPublisher()
    //        }
    //        let refreshTokenRequest = INVSRefreshTokenRequest.init(refreshToken: refreshToken)
    //        let request: AnyPublisher<INVSAccessModel, Error> = callRequest(endpoint: RefreshRepository.API.refreshToken(headers: headers, request: refreshTokenRequest))
    //        return request.flatMap { (accessModel) -> AnyPublisher<Bool, Error> in
    //            Session.session.user?.access = accessModel
    //            return Just.withErrorType(true, Error.self)
    //        }.eraseToAnyPublisher()
    //    }
}

// MARK: - Helpers

private extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func requestJSON<Value>(httpCodes: HTTPCodes) -> AnyPublisher<HTTPResponse<Value>, Error> where Value: Decodable {
        return tryMap {
            assert(!Thread.isMainThread)
            guard let code = ($0.1 as? HTTPURLResponse)?.statusCode else {
                JEWLogger.error($0)
                throw APIError.unexpectedResponse
            }
            guard httpCodes.contains(code) else {
                JEWLogger.error($0)
                throw APIError.httpCode(code)
            }
            return $0.0
        }
        .extractUnderlyingError()
        .decode(type: HTTPResponse<Value>.self, decoder: JSONDecoder())
        .receive(on: DispatchQueue.main)
        .tryMap{ response -> HTTPResponse<Value> in
            JEWLogger.info(response)
            return response
        }
        .eraseToAnyPublisher()
    }
}

struct HTTPResponse<Value>: Codable where Value: Codable {
    let data: Value
    let message: String?
    let response: BaseResponse
    
    struct BaseResponse: Codable {
        let code: Int
        let status: String
    }
}

struct HTTPRequest: Codable, JSONAble {
    let data: String
}
