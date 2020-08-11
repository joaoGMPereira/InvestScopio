//
//  INVSCEIWorker.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 27/05/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
typealias SuccessSimulationsCompletion = ([INVSSimulatorModel]) -> ()
typealias SuccessDeleteSimulationCompletion = (INVSDeleteSimulationResponse) -> ()
protocol INVSSimulationsWorkerProtocol {
    func getSimulations(successCompletion: @escaping(SuccessSimulationsCompletion), errorCompletion:@escaping(ErrorCompletion))
    func deleteSimulation(withSimulation simulation: INVSSimulatorModel, successCompletion: @escaping(SuccessDeleteSimulationCompletion), errorCompletion:@escaping(ErrorCompletion))
    func deleteAllSimulations(successCompletion: @escaping(SuccessDeleteSimulationCompletion), errorCompletion:@escaping(ErrorCompletion))
}

class INVSSimulationsWorker: NSObject,INVSSimulationsWorkerProtocol {

    func getSimulations(successCompletion: @escaping (SuccessSimulationsCompletion), errorCompletion: @escaping (ErrorCompletion)) {
//        INVSConector.connector.request(withRoute: ConnectorRoutes.userSimulations, responseClass: [INVSSimulatorModel].self, successCompletion: { (decodable) in
//            guard let simulations = decodable as? [INVSSimulatorModel] else {
//                errorCompletion(ConnectorError())
//                return
//            }
//            successCompletion(simulations)
//        }) { (connectorError) in
//            errorCompletion(connectorError)
//        }
    }
    
    func deleteSimulation(withSimulation simulation: INVSSimulatorModel, successCompletion: @escaping (SuccessDeleteSimulationCompletion), errorCompletion: @escaping (ErrorCompletion)) {
//        guard let idSimulation = simulation.id else {
//            errorCompletion(ConnectorError())
//            return
//        }
//        let deleteSimulation = INVSDeleteSimulationRequest.init(idSimulation: idSimulation)
//        INVSConector.connector.request(withRoute: ConnectorRoutes.deleteSimulation, method: .post, parameters: deleteSimulation, responseClass: INVSDeleteSimulationResponse.self, successCompletion: { (decodable) in
//            guard let deleteSimulation = decodable as? INVSDeleteSimulationResponse else {
//                errorCompletion(ConnectorError())
//                return
//            }
//            successCompletion(deleteSimulation)
//        }) { (connectorError) in
//            errorCompletion(connectorError)
//        }
    }
    
    func deleteAllSimulations(successCompletion: @escaping (SuccessDeleteSimulationCompletion), errorCompletion: @escaping (ErrorCompletion)) {
        INVSConector.connector.request(withRoute: ConnectorRoutes.deleteAllSimulations, method: .post, responseClass: INVSDeleteSimulationResponse.self, successCompletion: { (decodable) in
            guard let deleteSimulation = decodable as? INVSDeleteSimulationResponse else {
                errorCompletion(ConnectorError())
                return
            }
            successCompletion(deleteSimulation)
        }) { (connectorError) in
            errorCompletion(connectorError)
        }
    }
}

struct INVSDeleteSimulationRequest: JSONAble {
    let idSimulation: Int
}
