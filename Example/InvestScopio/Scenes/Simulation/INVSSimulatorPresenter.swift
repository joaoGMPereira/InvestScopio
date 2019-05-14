//
//  INVSSimulatorPresenter.swift
//  
//
//  Created by Joao Medeiros Pereira on 13/05/19.
//

import Foundation

protocol INVSSimulatorPresenterProtocol {
    func presentSimulationProjection(simulatorModel: INVSSimulatorModel)
    func presentErrorSimulationProjection(with messageError:String)
}

class INVSSimulatorPresenter: NSObject,INVSSimulatorPresenterProtocol {
   
    weak var controller: INVSSimutatorViewControlerProtocol?
    
    func presentSimulationProjection(simulatorModel: INVSSimulatorModel) {
        var simulatedValues = [INVSSimulatedValueModel]()
        if let totalMonths = simulatorModel.totalMonths {
            simulatedValues.append(setInitialValueObject(with: simulatorModel))
            for month in 1...totalMonths {
                let monthValue = simulatorModel.monthValue
                let profitability = checkProfitability(with: simulatorModel, month: month)
                let rescue = checkRescue(with: simulatorModel, month: month)

                let simulatedValue = INVSSimulatedValueModel(month: month, monthValue: monthValue, profitability: profitability, rescue: rescue, total: 0.0)
                simulatedValues.append(simulatedValue)
            }
        }
    }
    
    func presentErrorSimulationProjection(with messageError: String) {
        controller?.displayErrorSimulationProjection(with: messageError)
        
    }
    
}

extension INVSSimulatorPresenter {
    private func setInitialValueObject(with simulatorModel: INVSSimulatorModel) -> INVSSimulatedValueModel {
        return INVSSimulatedValueModel(month: nil, monthValue: simulatorModel.initialValue, profitability: nil, rescue: nil, total: nil)
    }
    
    private func checkRescue(with simulatorModel: INVSSimulatorModel, month: Int) -> Double {
        var lastRescue = INVSKeyChainWrapper.retrieveDouble(withKey: INVSConstants.SimulatorConstants.lastRescue.rawValue) ?? simulatorModel.initialMonthlyRescue ?? 0.0
        let increaseRescue = simulatorModel.increaseRescue ?? 0.0
        var nextGoalRescue = INVSKeyChainWrapper.retrieveDouble(withKey: INVSConstants.SimulatorConstants.lastGoalIncreaseRescue.rawValue) ?? simulatorModel.initialValue ?? 0.0
        
        let lastTotalValueRetrieved = INVSKeyChainWrapper.retrieveDouble(withKey: INVSConstants.SimulatorConstants.lastTotalValue.rawValue) ?? simulatorModel.initialValue ?? 0.0
        
        if let goalIncreaseRescue = simulatorModel.goalIncreaseRescue {
            let _ = INVSKeyChainWrapper.saveDouble(withValue: nextGoalRescue, andKey: INVSConstants.SimulatorConstants.lastGoalIncreaseRescue.rawValue)
            
            if lastTotalValueRetrieved >= nextGoalRescue {
                nextGoalRescue = lastTotalValueRetrieved + (goalIncreaseRescue/(simulatorModel.interestRate/100))
                let _ = INVSKeyChainWrapper.updateDouble(withValue: nextGoalRescue, andKey: INVSConstants.SimulatorConstants.lastGoalIncreaseRescue.rawValue)
                
                lastRescue = lastRescue + increaseRescue
                let _ = INVSKeyChainWrapper.saveDouble(withValue: lastRescue , andKey: INVSConstants.SimulatorConstants.lastRescue.rawValue)
                
            }
            
        }
        return lastRescue
    }
    
    private func checkProfitability(with simulatorModel: INVSSimulatorModel, month: Int) -> Double {
        var lastTotalValue = simulatorModel.initialValue ?? 0
        var profitability = 0.0
        if let lastTotalValueRetrieved = INVSKeyChainWrapper.retrieveDouble(withKey: INVSConstants.SimulatorConstants.lastTotalValue.rawValue) {
            lastTotalValue = lastTotalValueRetrieved
        } else {
            let _ = INVSKeyChainWrapper.saveDouble(withValue: lastTotalValue, andKey: INVSConstants.SimulatorConstants.lastTotalValue.rawValue)
        }
        profitability = lastTotalValue * ((simulatorModel.interestRate ?? 0.0)/100)
        lastTotalValue = lastTotalValue + profitability
        let _ = INVSKeyChainWrapper.updateDouble(withValue: lastTotalValue, andKey: INVSConstants.SimulatorConstants.lastTotalValue.rawValue)
        
        return profitability
    }
}

//var initialValue: Double?
//var monthValue: Double?
//var interestRate: Double?
//var totalMonths: Int?
//var monthlyRescue: Double?
//var increaseRescue: Double?
//var goalIncreaseRescue: Double?
