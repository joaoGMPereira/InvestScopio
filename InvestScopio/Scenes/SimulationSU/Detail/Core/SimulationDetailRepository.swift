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

protocol SimulationDetailRepositoryProtocol: WebRepository {
    func simulationDetail(simulation: SimulatorModel) -> AnyPublisher<HTTPResponse<[INVSSimulatedValueModel]>, Error>
}

struct SimulationDetailRepository: SimulationDetailRepositoryProtocol {
    
    func simulationDetail(simulation: SimulatorModel) -> AnyPublisher<HTTPResponse<[INVSSimulatedValueModel]>, Error> {
        return call(endpoint: API.simulationDetail(simulation))
    }
}

// MARK: - Endpoints

extension SimulationDetailRepository {
    enum API {
        case simulationDetail(_ request: SimulatorModel)
    }
}

extension SimulationDetailRepository.API: APICall {
    
    var route: ConnectorRoutes {
        switch self {
        case .simulationDetail:
            return .simulation
        }
    }
    var method: HTTPMethod {
        switch self {
        case .simulationDetail:
            return .post
        }
    }
    var headers: [String: String]? {
        return ["Content-Type": "application/json", "session-token": JEWSession.session.services.sessionToken]
    }
    
    func body() -> HTTPRequest? {
        switch self {
        case .simulationDetail(let request):
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: request.toDict(),
                options: []), let encryptedAESCryptoString = AES256Crypter.crypto.encrypt(theJSONData) {
                return HTTPRequest(data: encryptedAESCryptoString)
            }
            return nil
        }
    }
}
