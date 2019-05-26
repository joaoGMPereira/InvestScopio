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
    
    func simulationProjection() {
        INVSKeyChainWrapper.clear()
        self.presenter?.presentSimulationProjection(simulatorModel: simulatorModel)
    }
    
}
