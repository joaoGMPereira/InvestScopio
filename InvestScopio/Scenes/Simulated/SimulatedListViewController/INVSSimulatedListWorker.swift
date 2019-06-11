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
    func simulationProjection(with simulatorModel: INVSSimulatorModel, successCompletionHandler: @escaping(SuccessSimulatedHandler), errorCompletionHandler:@escaping(ErrorSimulatedHandler))
}

class INVSSimulatedListWorker: NSObject,INVSSimulatedListWorkerProtocol {
    func simulationProjection(with simulatorModel: INVSSimulatorModel, successCompletionHandler: @escaping (SuccessSimulatedHandler), errorCompletionHandler: @escaping (ErrorSimulatedHandler)) {
        let headers = ["Content-Type": "application/json"]
        INVSConector.connector.request(withURL: INVSConector.getURL(withRoute: "simulation/values"), method: .post, parameters: simulatorModel, headers: headers) { (response) in
            guard let responseData = response.data else {
                errorCompletionHandler(INVSConstants.SimulationErrors.defaultMessageError.rawValue, true,.error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let simulatedValues = try decoder.decode([INVSSimulatedValueModel].self, from: responseData)
                print(simulatedValues)
                successCompletionHandler(simulatedValues)
            } catch let error {
                print(error.localizedDescription)
                errorCompletionHandler(INVSConstants.SimulationErrors.defaultMessageError.rawValue, true,.error)
            }
        }
    }
    

}
