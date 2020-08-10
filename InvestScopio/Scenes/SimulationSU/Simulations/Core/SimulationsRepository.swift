//
//  RegisterRepository.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 20/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Combine
import Foundation


protocol SimulationsRepositoryProtocol: WebRepository {
    func simulations() -> AnyPublisher<HTTPResponse<[INVSSimulatorModel]>, Error>
}

struct SimulationsRepository: SimulationsRepositoryProtocol {
    
    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(session: URLSession? = nil, baseURL: String? = nil) {
        self.session = Self.configuredURLSession()
        self.baseURL = "https://invest-scopio-dev-backend.herokuapp.com/api/v1"
    }
    
    func simulations() -> AnyPublisher<HTTPResponse<[INVSSimulatorModel]>, Error> {
        return call(endpoint: API.simulations, shouldRefreshToken: true)
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
        guard let accessToken = Session.session.user?.access?.accessToken else { return nil }
        return ["Content-Type": "application/json", "Authorization": accessToken]
    }
    func body() -> HTTPRequest? {
        return nil
    }
}
