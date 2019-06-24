//
//  INVSSimutatorInteractor.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 13/05/19.
//

import Foundation
import UIKit
protocol INVSSimulatedListInteractorProtocol {
    func simulationProjection(withViewController viewController: UIViewController?)
}

class INVSSimulatedListInteractor: NSObject,INVSSimulatedListInteractorProtocol {
    
    var presenter: INVSSimulatedListPresenterProtocol?
    var simulatorModel = INVSSimulatorModel()
    var worker: INVSSimulatedListWorkerProtocol = INVSSimulatedListWorker()
    var callService: ServiceType = INVSSession.session.callService
    func simulationProjection(withViewController viewController: UIViewController?) {
        if callService == .heroku || callService == .localHost {
            worker.simulationProjection(with: simulatorModel, viewController: viewController, successCompletionHandler: { (simulatedValues) in
                self.presenter?.presentResultSimulationProjection(withSimulatorModel: self.simulatorModel, simulatedValues: simulatedValues)
            }) { (message, shouldHideAutomatically, popupType) in
                self.presenter?.presentErrorSimulationProjection(messageError: message, shouldHideAutomatically: shouldHideAutomatically, popupType: popupType)
            }
        } else {
            INVSKeyChainWrapper.clear()
            self.presenter?.presentSimulationProjection(simulatorModel: simulatorModel)
        }
    }
    
}
