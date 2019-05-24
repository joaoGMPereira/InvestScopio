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

}
