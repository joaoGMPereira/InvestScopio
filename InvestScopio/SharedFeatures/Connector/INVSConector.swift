//
//  Connector.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 05/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import Alamofire
import JewFeatures
typealias SuccessResponse = (Decodable) -> ()
typealias FinishResponse = () -> ()
typealias SuccessRefreshResponse = (_ shouldUpdateHeaders: Bool) -> ()
typealias ErrorCompletion = (ConnectorError) -> ()

final class INVSConector {
    
    // Can't init is singleton
    private init() { }
    
    static let connector = INVSConector()
    
    static func getURL(withRoute route: String) -> URL? {
        var baseURL = URL(string: "\(INVSConstants.INVSServicesConstants.apiV1.rawValue)\(route)")
        if Session.session.isDev() {
            baseURL = Session.session.callService == .heroku ? URL(string: "\(INVSConstants.INVSServicesConstants.apiV1Dev.rawValue)\(route)") : URL(string: "\(INVSConstants.INVSServicesConstants.localHost.rawValue)\(route)")
        }
        return URL(string: "\(JEWConstants.Services.dev.rawValue)\(route)")
    }
}
