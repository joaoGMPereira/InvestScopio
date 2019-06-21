//
//  Connector.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 05/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import Alamofire
typealias SuccessResponse = (Decodable) -> Void
typealias ErrorResponse = (DefaultError) -> Void


enum ConnectorError: Error {
    case parseError
    
    static func checkErrorCode(_ connectorError: ConnectorError) -> DefaultError {
        switch connectorError {
        case .parseError:
            return DefaultError.default()
        }
    }
}

struct DefaultError: Decodable {
    var error: Bool = true
    let reason: String
    
    static func `default`() -> DefaultError {
        return DefaultError(error: true, reason: INVSFloatingTextFieldType.defaultErrorMessage())
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
    
    func request<T: Decodable>(withURL url: URL?, method: HTTPMethod = .get, parameters: JSONAble? = nil, responseClass: T.Type, headers: HTTPHeaders? = nil, shouldRetry: Bool = false, successCompletion: @escaping(SuccessResponse), errorCompletion: @escaping(ErrorResponse)) {
        
        guard let url = url else {
            return
        }
        
        requestBlock(withURL: url, method: method, parameters: parameters, responseClass: responseClass, headers: headers, successCompletion: { (decodable) in
            successCompletion(decodable)
        }) { (error) in
            if shouldRetry && error.error {
                self.request(withURL: url, method: method, parameters: parameters, responseClass: responseClass, headers: headers, shouldRetry: false, successCompletion: successCompletion, errorCompletion: errorCompletion)
                return
            }
            errorCompletion(error)
        }
    }
    
    private func requestBlock<T: Decodable>(withURL url: URL, method: HTTPMethod = .get, parameters: JSONAble? = nil, responseClass: T.Type, headers: HTTPHeaders? = nil, successCompletion: @escaping(SuccessResponse), errorCompletion: @escaping(ErrorResponse)) {
        Alamofire.request(url, method: method, parameters: parameters?.toDict(), encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            let responseResult = response.result
            if responseResult.error != nil {
                do {
                    if let data = response.data {
                        var defaultError = try JSONDecoder().decode(DefaultError.self, from: data)
                        defaultError.error = false
                        errorCompletion(defaultError)
                    } else {
                        errorCompletion(ConnectorError.checkErrorCode(.parseError))
                    }
                    return
                }
                catch {
                    errorCompletion(ConnectorError.checkErrorCode(.parseError))
                    return
                }
                
            }
            switch responseResult {
            case .success:
                do {
                    if let data = response.data {
                        let decodable = try JSONDecoder().decode(T.self, from: data)
                        successCompletion(decodable)
                    } else {
                        errorCompletion(ConnectorError.checkErrorCode(.parseError))
                    }
                    break
                }
                catch {
                    errorCompletion(ConnectorError.checkErrorCode(.parseError))
                    break
                }
            case .failure:
                errorCompletion(DefaultError.default())
                break
            }
        }
    }
}
