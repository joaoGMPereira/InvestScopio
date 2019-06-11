//
//  INVSConstants.swift
//  InvestScopio_Example
//
//  Created by Joao Medeiros Pereira on 14/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

enum INVSConstants {
    enum SimulatorKeyChainConstants: String {
        case lastTotalValue = "INVSLastTotalValue"
        case lastProfitabilityUntilNextIncreaseRescue = "INVSLastProfitabilityUntilNextIncreaseRescue"
//        case lastGoalIncreaseRescue = "INVSLastGoalIncreaseRescue"
        case lastRescue = "INVSLastRescue"
    }
    
    enum SimulatorCellConstants: String {
        case cellIdentifier = "INVSSimulatorCell"
        case tableViewHeaderName = "INVSSimulatorHeaderView"
    }
    
    enum INVSTransactionsViewControllersID: String {
        case startSimulatedViewController = "INVSStartSimulatedViewController"
    }
    
    enum INVSServicesConstants: String {
        case apiV1 = "https://invest-scopio-backend.herokuapp.com/api/"
        case localAPI = "http://localhost:8080/api/"
        case version = "version"
    }
    
    enum SimulationErrors: String {
        case defaultTitleError = "Ocorreu um problema, Tente novamente.\n\n"
        case defaultMessageError = "Não foi possível fazer o cálculo da simulação."
    }

}
