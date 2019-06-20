//
//  Connector.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 05/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import Alamofire
typealias successResponse = (Decodable) -> Void
typealias errorResponse = (Error) -> Void


enum ConnectorError: Error {
    case unknownError
    case connectionError
    case invalidCredentials
    case parseError
    case invalidRequest
    case notFound
    case invalidResponse
    case serverError
    case serverUnavailable
    case timeOut
    case unsuppotedURL
    case codeEmailAlreadyInUse
    
    static func checkErrorCode(_ errorCode: Int) -> ConnectorError {
        switch errorCode {
        case 400:
            return .invalidRequest
        case 401:
            return .invalidCredentials
        case 404:
            return .notFound
        case 999:
            return .parseError
        case 17007:
            return .codeEmailAlreadyInUse
        default:
            return .unknownError
        }
    }
}

final class INVSConector {
    
    // Can't init is singleton
    private init() { }
    
    static let connector = INVSConector()
    
    static func getURL(withRoute route: String) -> URL? {
        var baseURL = URL(string: "\(INVSConstants.INVSServicesConstants.apiV1.rawValue)\(route)")
        if INVSSession.session.isDev() {
            baseURL = INVSSession.session.callService == .heroku ? URL(string: "\(INVSConstants.INVSServicesConstants.apiV1Dev.rawValue)\(route)") : URL(string: "\(INVSConstants.INVSServicesConstants.localHost.rawValue)\(route)")
        }
        return baseURL
    }
    
    static func getVersion() -> URL? {
        return getURL(withRoute: INVSConstants.INVSServicesConstants.version.rawValue)
    }
    
    func request<T: Decodable>(withURL url: URL?, method: HTTPMethod = .get, parameters: JSONAble? = nil, class: T.Type, headers: HTTPHeaders? = nil, successCompletion: @escaping(successResponse), errorCompletion: @escaping(errorResponse)) {
        guard let url = url else {
            return
        }
        Alamofire.request(url, method: method, parameters: parameters?.toDict(), encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            let responseResult = response.result
            if let error = responseResult.error {
                do {
                    if let data = response.data {
                        let decodable = try JSONDecoder().decode(DefaultError.self, from: data)
                        errorCompletion(ConnectorError.checkErrorCode(17007))
                    } else {
                        errorCompletion(ConnectorError.checkErrorCode(999))
                    }
                }
                catch {
                    errorCompletion(ConnectorError.checkErrorCode(999))
                }
                errorCompletion(error)
                return
            }
            switch responseResult {
            case .success:
                do {
                    if let data = response.data {
                        let decodable = try JSONDecoder().decode(T.self, from: data)
                        successCompletion(decodable)
                    } else {
                        errorCompletion(ConnectorError.checkErrorCode(999))
                    }
                    break
                }
                catch {
                    errorCompletion(ConnectorError.checkErrorCode(999))
                    break
                }
            case .failure(let error):
                errorCompletion(error)
                break
            }
        }
    }
}


struct DefaultError: Decodable {
    let error: Bool
    let reason: String
}
