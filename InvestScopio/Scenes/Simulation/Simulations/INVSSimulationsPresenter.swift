//
//  INVSSMarketPresenter.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 29/05/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation

protocol INVSSimulationsPresenterProtocol {
    func presentSimulations(withSimulations simulations: [INVSSimulatorModel])
    func presentDeletedSimulation(withDeleteSimulationSimulation deletedSimulation: INVSDeleteSimulationResponse)
    func presentDeletedAllSimulations(withDeleteSimulationSimulation deletedSimulation: INVSDeleteSimulationResponse)
    func presentError(error: ConnectorError)
}

class INVSSimulationsPresenter: NSObject,INVSSimulationsPresenterProtocol {
    
    weak var controller: INVSSimulationsViewControllerProtocol?
    
    func presentSimulations(withSimulations simulations: [INVSSimulatorModel]) {
        controller?.displaySimulations(withSimulations: simulations)
    }
    
    func presentDeletedSimulation(withDeleteSimulationSimulation deletedSimulation: INVSDeleteSimulationResponse) {
        controller?.displayDeleteSimulation(withDeleteSimulation: deletedSimulation)
    }
    
    func presentDeletedAllSimulations(withDeleteSimulationSimulation deletedSimulation: INVSDeleteSimulationResponse) {
        controller?.displayDeleteAllSimulations(withDeleteSimulation: deletedSimulation)
    }
    
    func presentError(error: ConnectorError) {
        switch error.error {
        case .none:
            controller?.displayErrorDefault(titleError: error.title, messageError: error.message, shouldHideAutomatically: true, popupType: .error)
        case .authentication, .sessionExpired:
            controller?.displayErrorAuthentication(titleError: error.title, messageError: error.message, shouldRetry: error.shouldRetry)
        case .settings:
            controller?.displayErrorSettings(titleError: error.title, messageError: error.message)
        case .logout:
            controller?.displayErrorLogout(titleError: error.title, messageError: error.message)
            
        }
    }

}
