//
//  RegisterRepository.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 20/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Combine
import Foundation
import JewFeatures

protocol SimulationsRepositoryProtocol: WebRepository {
    func simulations() -> AnyPublisher<HTTPResponse<[INVSSimulatorModel]>, Error>
}

struct SimulationsRepository: SimulationsRepositoryProtocol {
    
    func simulations() -> AnyPublisher<HTTPResponse<[INVSSimulatorModel]>, Error> {
        return call(endpoint: API.simulations)
    }
}

// MARK: - Endpoints

extension SimulationsRepository {
    enum API {
        case simulations
    }
}

extension SimulationsRepository.API: APICall {
    
    var route: ConnectorRoutes {
        switch self {
        case .simulations:
            return .userSimulations
        }
    }
    var method: HTTPMethod {
        switch self {
        case .simulations:
            return .get
        }
    }
    var headers: [String: String]? {
        return ["Content-Type": "application/json", "session-token": JEWSession.session.services.sessionToken]
    }
    func body() -> HTTPRequest? {
        return nil
    }
}
