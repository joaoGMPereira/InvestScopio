//
//  INVSConnectorHelpers.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 22/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import JewFeatures

enum ConnectorRoutes {
    case signup
    case publicKey
    case accessToken
    case signin
    case logout
    case simulation
    case userSimulations
    case deleteSimulation(_ id: String)
    case deleteAllSimulations
    case evaluate
    case refreshToken
    case sendNPS
    case getNPS(_ versionApp: String)
    
    func getRoute() -> URL? {
        switch self {
        case .signup:
            return JEWConnector.getURL(withRoute: "/register")
        case .publicKey:
            return JEWConnector.getURL(withRoute: "/public-key")
        case .accessToken:
            return JEWConnector.getURL(withRoute: "/access-token")
        case .signin:
            return JEWConnector.getURL(withRoute: "/login")
        case .logout:
            return JEWConnector.getURL(withRoute: "/account/logout")
        case .simulation:
            return JEWConnector.getURL(withRoute: "/simulation")
        case .userSimulations:
            return JEWConnector.getURL(withRoute: "/userSimulations")
        case .deleteSimulation(let id):
            return JEWConnector.getURL(withRoute: "/simulation/\(id)")
        case .deleteAllSimulations:
            return JEWConnector.getURL(withRoute: "/deleteAllSimulations")
        case .evaluate:
            return JEWConnector.getURL(withRoute: "/evaluation/evaluate")
        case .refreshToken:
            return JEWConnector.getURL(withRoute: "/account/refresh-token")
        case .getNPS(let versionApp):
            return JEWConnector.getURL(withRoute: "/nps/\(versionApp)")
        case .sendNPS:
            return JEWConnector.getURL(withRoute: "/nps")
        }
    }
    
    static func setBaseURL() {
        var baseURL = AppConstants.ServicesConstants.apiV1.rawValue
        if JEWSession.session.services.isDev() {
            baseURL = JEWSession.session.services.callService == .heroku ? AppConstants.ServicesConstants.apiV1Dev.rawValue : JEWConstants.Services.localHost.rawValue
        }
        JEWConnector.connector.baseURL = baseURL
    }
}
