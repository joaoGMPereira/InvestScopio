//
//  INVSSimutatorInteractor.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 13/05/19.
//

import Foundation

protocol INVSSimulatorInteractorProtocol {
    func simulationProjection()
    func clearTextFields()
}

class INVSSimulatorInteractor: NSObject,INVSSimulatorInteractorProtocol {
    var presenter: INVSSimulatorPresenterProtocol?
    var worker: INVSSimulatorWorkerProtocol = INVSSimulatorWorker()
    var allTextFields = [INVSFloatingTextField]()
    
    func simulationProjection() {
        worker.simulationProjection(with: allTextFields, successCompletionHandler: { (simulatorModel) in
            self.presenter?.presentSimulationProjection(simulatorModel: simulatorModel)
        }) { (messageError) in
            self.presenter?.presentErrorSimulationProjection(with: messageError)
        }
    }
    
    func clearTextFields() {
        for textField in allTextFields {
            textField.clear()
        }
    }
    
}
