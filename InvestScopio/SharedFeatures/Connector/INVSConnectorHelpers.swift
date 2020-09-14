//
//  INVSConnectorHelpers.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 22/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import UIKit

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
    
    func getRoute() -> URL? {
        switch self {
        case .signup:
            return INVSConector.getURL(withRoute: "/register")
        case .publicKey:
            return INVSConector.getURL(withRoute: "/public-key")
        case .accessToken:
            return INVSConector.getURL(withRoute: "/access-token")
        case .signin:
            return INVSConector.getURL(withRoute: "/login")
        case .logout:
            return INVSConector.getURL(withRoute: "/account/logout")
        case .simulation:
            return INVSConector.getURL(withRoute: "/simulation")
        case .userSimulations:
            return INVSConector.getURL(withRoute: "/userSimulations")
        case .deleteSimulation(let id):
            return INVSConector.getURL(withRoute: "/simulation/\(id)")
        case .deleteAllSimulations:
            return INVSConector.getURL(withRoute: "/deleteAllSimulations")
        case .evaluate:
            return INVSConector.getURL(withRoute: "/evaluation/evaluate")
        case .refreshToken:
            return INVSConector.getURL(withRoute: "/account/refresh-token")
        }
    }
}
