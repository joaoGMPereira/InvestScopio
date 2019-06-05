//
//  INVSConnectorRouter.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 05/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import Alamofire
enum INVSConnectorRouter: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        return URLRequest.init(url: URL.init(string: "\(INVSConstants.INVSServicesConstants.apiV1.rawValue)\(INVSConstants.INVSServicesConstants.version.rawValue)")!)
    }
    
    static let baseURLString = INVSConstants.INVSServicesConstants.apiV1.rawValue
    
    case CreateUser([String: AnyObject])
    case ReadUser(String)
    case UpdateUser(String, [String: AnyObject])
    case DestroyUser(String)
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .CreateUser:
            return .post
        case .ReadUser:
            return .get
        case .UpdateUser:
            return .put
        case .DestroyUser:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .CreateUser:
            return "/users"
        case .ReadUser(let username):
            return "/users/\(username)"
        case .UpdateUser(let username, _):
            return "/users/\(username)"
        case .DestroyUser(let username):
            return "/users/\(username)"
        }
    }
}
