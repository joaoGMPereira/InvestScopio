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
    var session: URLSession { Self.configuredURLSession() }
    var bgQueue: DispatchQueue { DispatchQueue(label: "bg_parse_queue") }
}

extension WebRepository {
    
    static func configuredURLSession() -> URLSession {
        return URLSession(configuration: .default)
    }
    
    func call<Value>(endpoint: APICall, httpCodes: HTTPCodes = .success) -> AnyPublisher<HTTPResponse<Value>, Error>
        where Value: Decodable {
            do {
                let request = try endpoint.urlRequest()
                JEWLogger.info(request)
                return URLSession.shared
                    .dataTaskPublisher(for: request)
                    .requestJSON(httpCodes: httpCodes)
            } catch let error {
                return Fail<HTTPResponse<Value>, Error>(error: error).eraseToAnyPublisher()
            }
    }
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
