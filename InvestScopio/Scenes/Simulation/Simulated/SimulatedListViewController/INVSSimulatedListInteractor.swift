//
//  INVSSimutatorInteractor.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 13/05/19.
//

import Foundation
import UIKit
protocol INVSSimulatedListInteractorProtocol {
    func simulationProjection()
}

class INVSSimulatedListInteractor: NSObject,INVSSimulatedListInteractorProtocol {
    
    var presenter: INVSSimulatedListPresenterProtocol?
    var simulatorModel = INVSSimulatorModel()
    var worker: INVSSimulatedListWorkerProtocol = INVSSimulatedListWorker()
    var callService: ServiceType = Session.session.callService
    func simulationProjection() {
        if callService == .heroku || callService == .localHost {
            worker.simulationProjection(with: simulatorModel, successCompletionHandler: { (simulatedValues) in
                self.presenter?.presentResultSimulationProjection(withSimulatorModel: self.simulatorModel, simulatedValues: simulatedValues)
            }) { (connectorError) in
                self.presenter?.presentErrorSimulationProjection(error: connectorError)
            }
        } else {
            INVSKeyChainWrapper.clear()
            self.presenter?.presentSimulationProjection(simulatorModel: simulatorModel)
        }
    }
    
}
