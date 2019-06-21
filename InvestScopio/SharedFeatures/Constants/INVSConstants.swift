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
        case apiV1 = "https://invest-scopio-backend.herokuapp.com/api/v1"
        case apiV1Dev = "https://invest-scopio-dev-backend.herokuapp.com/api/v1"
        case localHost = "http://localhost:8080/api/v1"
        case version = "version"
    }
    
    enum SimulationErrors: String {
        case defaultTitleError = "Ocorreu um problema, Tente novamente.\n\n"
        case defaultMessageError = "Não foi possível fazer o cálculo da simulação."
    }
    
    enum LoginKeyChainConstants: String {
        case lastLoginEmail = "INVSRememberMeEmail"
        case lastLoginSecurity = "INVSRememberMeSecurity"
    }
    
    enum OfflineViewControler: String {
        case title = "Atenção"
        case message = "Sem efetuar o login você não terá\nacesso ao seu histórico de simulações."
    }

}
