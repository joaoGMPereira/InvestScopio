//
//  Connector.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 05/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import Alamofire
typealias connectorResponse = (DataResponse<Any>) -> Void
final class INVSConector {
    
    // Can't init is singleton
    private init() { }
    
    static let connector = INVSConector()
    
    static func getURL(withRoute route: String) -> URL? {
        return URL(string: "\(INVSConstants.INVSServicesConstants.apiV1.rawValue)\(route)")
    }
    
    static func getVersion() -> URL? {
        return getURL(withRoute: INVSConstants.INVSServicesConstants.version.rawValue)
    }
    
    func request(withURL url: URL?, completion: @escaping(connectorResponse)) {
        guard let url = url else {
            return
        }
        Alamofire.request(url, method: .get).validate().responseJSON { (response) in
            completion(response)
        }
    }

}

