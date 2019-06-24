//
//  INVSSimulatedListWorker.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 10/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import Alamofire
typealias SuccessSimulatedHandler = ([INVSSimulatedValueModel]) -> Void
typealias ErrorSimulatedHandler = (_ messageError:String, _ shouldHideAutomatically:Bool, _ popupType:INVSPopupMessageType) ->()

protocol INVSSimulatedListWorkerProtocol {
    func simulationProjection(with simulatorModel: INVSSimulatorModel, viewController: UIViewController?, successCompletionHandler: @escaping(SuccessSimulatedHandler), errorCompletionHandler:@escaping(ErrorSimulatedHandler))
}

class INVSSimulatedListWorker: NSObject,INVSSimulatedListWorkerProtocol {
    func simulationProjection(with simulatorModel: INVSSimulatorModel,viewController: UIViewController?, successCompletionHandler: @escaping (SuccessSimulatedHandler), errorCompletionHandler: @escaping (ErrorSimulatedHandler)) {
        guard let headers = ["Content-Type": "application/json", "Authorization": INVSSession.session.user?.access?.accessToken] as? HTTPHeaders else {
            errorCompletionHandler(INVSConstants.SimulationErrors.defaultMessageError.rawValue, true,.error)
            return
        }
        INVSConector.connector.request(withRoute: ConnectorRoutes.simulation, method: .post, parameters: simulatorModel, responseClass: [INVSSimulatedValueModel].self, headers: headers, lastViewController: viewController, successCompletion: { (decodable) in
            guard let simulatedValues = decodable as? [INVSSimulatedValueModel] else {
                errorCompletionHandler(INVSConstants.SimulationErrors.defaultMessageError.rawValue, true,.error)
                return
            }
            successCompletionHandler(simulatedValues)
        }) { (error) in
            errorCompletionHandler(INVSConstants.SimulationErrors.defaultMessageError.rawValue, true,.error)
        }
}
}
