//
//  INVSSMarketInteractor.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 29/05/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import UIKit
protocol INVSSimulationsInteractorProtocol {
    func getSimulations()
    func deleteSimulation(withSimulation simulation: INVSSimulatorModel)
    func deleteAllSimulations()
}

class INVSSimulationsInteractor: NSObject, INVSSimulationsInteractorProtocol {
    
    var presenter: INVSSimulationsPresenterProtocol?
    var worker: INVSSimulationsWorkerProtocol = INVSSimulationsWorker()
    
  
    func getSimulations() {
        worker.getSimulations(successCompletion: { (simulations) in
            self.presenter?.presentSimulations(withSimulations: simulations)
        }) { (connectorError) in
            self.presenter?.presentError(error: connectorError)
        }
    }
    
    func deleteSimulation(withSimulation simulation: INVSSimulatorModel) {
        worker.deleteSimulation(withSimulation: simulation, successCompletion: { (deleteResponse) in
            self.presenter?.presentDeletedSimulation(withDeleteSimulationSimulation: deleteResponse)
        }) { (connectorError) in
            self.presenter?.presentError(error: connectorError)
        }
    }
    
    func deleteAllSimulations() {
        worker.deleteAllSimulations(successCompletion: { (deleteResponse) in
            self.presenter?.presentDeletedAllSimulations(withDeleteSimulationSimulation: deleteResponse)
        }) { (connectorError) in
            self.presenter?.presentError(error: connectorError)
        }
    }
}
