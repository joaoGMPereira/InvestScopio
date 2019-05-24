//
//  INVSSimutatorInteractor.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 13/05/19.
//

import Foundation
import UIKit
protocol INVSSimulatedInteractorProtocol {
    func simulationProjection()
}

class INVSSimulatedInteractor: NSObject,INVSSimulatedInteractorProtocol {
    
    var presenter: INVSSimulatedPresenterProtocol?
    var simulatorModel = INVSSimulatorModel()
    
    func simulationProjection() {
        self.presenter?.presentLoading()
        INVSKeyChainWrapper.clear()
        self.presenter?.presentSimulationProjection(simulatorModel: simulatorModel)
    }
    
}
