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
    func deleteSimulations() -> AnyPublisher<HTTPResponse<DeleteSimulationModel>, Error>
}

struct SimulationsRepository: SimulationsRepositoryProtocol {
    
    func simulations() -> AnyPublisher<HTTPResponse<[INVSSimulatorModel]>, Error> {
        return call(endpoint: API.simulations)
    }
    
    func deleteSimulations() -> AnyPublisher<HTTPResponse<DeleteSimulationModel>, Error> {
        return call(endpoint: API.removeAll)
    }
}

// MARK: - Endpoints

extension SimulationsRepository {
    enum API {
        case simulations
        case removeAll
    }
}

extension SimulationsRepository.API: APICall {
    
    var route: ConnectorRoutes {
        switch self {
        case .simulations:
            return .userSimulations
        case .removeAll:
            return .deleteAllSimulations
        }
    }
    var method: HTTPMethod {
        switch self {
        case .simulations:
            return .get
        case .removeAll:
            return .delete
        }
    }
    var headers: [String: String]? {
        return ["Content-Type": "application/json", "session-token": JEWSession.session.services.sessionToken]
    }
    func body() -> HTTPRequest? {
        return nil
    }
}
