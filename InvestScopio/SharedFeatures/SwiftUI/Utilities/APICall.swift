//
//  APICall.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 23.10.2019.
//  Copyright © 2019 Alexey Naumov. All rights reserved.
//

import Foundation
import JewFeatures

protocol APICall {
    var route: ConnectorRoutes { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var sessionToken: Bool { get }
    func body() -> HTTPRequest?
}

extension APICall {
    var sessionToken: Bool {
        return true
    }
}

enum APIError: Error {
    case `default`
    case customError(String)
    case logout
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .customError(let message):
            return message
        case .logout:
            return "Sessão finalizada!"
        case .default:
            return "Atenção!\nDesculpe, tivemos algum problema, tente novamente mais tarde!"
        }
    }
}

extension APICall {
    func urlRequest() throws -> URLRequest {
        guard let url = route.getRoute() else {
            throw APIError.default
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        var allHeaders = headers
        if sessionToken {
            allHeaders?["session-token"] = JEWSession.session.services.sessionToken
        }
        request.allHTTPHeaderFields = allHeaders
        request.httpBody = try setBody()
        return request
    }
    
    private func setBody() throws -> Data? {
        if let body = body(), let theJSONData = try? JSONSerialization.data(
            withJSONObject: body.toDict(),
            options: []) {
            return theJSONData
        }
        return nil
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}
