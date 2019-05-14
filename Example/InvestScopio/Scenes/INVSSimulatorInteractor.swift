//
//  INVSSimutatorInteractor.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 13/05/19.
//

import Foundation

protocol INVSSimulatorInteractorProtocol {
    func simulationProjection(with textfields:[INVSFloatingTextField])
}

class INVSSimulatorInteractor: NSObject,INVSSimulatorInteractorProtocol {
    var presenter: INVSSimulatorPresenterProtocol?
    var worker: INVSSimulatorWorkerProtocol = INVSSimulatorWorker()
    
    func simulationProjection(with textfields: [INVSFloatingTextField]) {
        worker.simulationProjection(with: textfields, successCompletionHandler: { (finished) in
            self.presenter?.presentSimulationProjection()
        }) { (messageError) in
            self.presenter?.presentErrorSimulationProjection(with: messageError)
        }
    }
    
}
