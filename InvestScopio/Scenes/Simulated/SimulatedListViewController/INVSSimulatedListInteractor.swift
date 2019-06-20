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
    var callService: ServiceType = INVSSession.session.callService
    func simulationProjection() {
        INVSKeyChainWrapper.clear()
        if callService == .heroku {
            worker.simulationProjection(with: simulatorModel, successCompletionHandler: { (simulatedValues) in
                self.presenter?.presentResultSimulationProjection(withSimulatorModel: self.simulatorModel, simulatedValues: simulatedValues)
            }) { (message, shouldHideAutomatically, popupType) in
                self.presenter?.presentErrorSimulationProjection(messageError: message, shouldHideAutomatically: shouldHideAutomatically, popupType: popupType)
            }
        } else {
            self.presenter?.presentSimulationProjection(simulatorModel: simulatorModel)
        }
    }
    
}
