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
    func presentClear()
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
                let updatedTotal = updateTotalValue(withRescue: rescue, simulatorModel: simulatorModel)
                let simulatedValue = INVSSimulatedValueModel(month: month, monthValue: monthValue, profitability: profitability, rescue: rescue, total: updatedTotal)
                simulatedValues.append(simulatedValue)
            }
        }
        controller?.displaySimulationProjection(with: simulatedValues)
    }
    
    func presentErrorSimulationProjection(with messageError: String) {
        controller?.displayErrorSimulationProjection(with: messageError)
        
    }
    
    func presentClear() {
         controller?.displayClear()
    }
    
}

extension INVSSimulatorPresenter {
    
    private func setInitialValueObject(with simulatorModel: INVSSimulatorModel) -> INVSSimulatedValueModel {
        return INVSSimulatedValueModel(month: nil, monthValue: simulatorModel.initialValue, profitability: nil, rescue: nil, total: nil)
    }
    
    private func updateTotalValue(withRescue rescue: Double, simulatorModel: INVSSimulatorModel) -> Double {
        var lastTotalValueRetrieved = INVSKeyChainWrapper.retrieveDouble(withKey: INVSConstants.SimulatorConstants.lastTotalValue.rawValue) ?? simulatorModel.initialValue ?? 0.0
        lastTotalValueRetrieved = lastTotalValueRetrieved - rescue
        let _ = INVSKeyChainWrapper.updateDouble(withValue: lastTotalValueRetrieved, andKey: INVSConstants.SimulatorConstants.lastTotalValue.rawValue)
        return lastTotalValueRetrieved
    }
    
    private func checkProfitability(with simulatorModel: INVSSimulatorModel, month: Int) -> Double {
        var lastTotalValue = simulatorModel.initialValue ?? 0
        var profitability = 0.0
        lastTotalValue = checkTotalValue(with: lastTotalValue)
        profitability = lastTotalValue * ((simulatorModel.interestRate ?? 0.0)/100)
        lastTotalValue = lastTotalValue + profitability
        let _ = INVSKeyChainWrapper.updateDouble(withValue: lastTotalValue, andKey: INVSConstants.SimulatorConstants.lastTotalValue.rawValue)
        
        return profitability
    }
    
    private func checkTotalValue(with totalValue: Double) -> Double {
        var lastTotalValue = totalValue
        if let lastTotalValueRetrieved = INVSKeyChainWrapper.retrieveDouble(withKey: INVSConstants.SimulatorConstants.lastTotalValue.rawValue) {
            lastTotalValue = lastTotalValueRetrieved
        } else {
            let _ = INVSKeyChainWrapper.saveDouble(withValue: lastTotalValue, andKey: INVSConstants.SimulatorConstants.lastTotalValue.rawValue)
        }
        return lastTotalValue
    }
    
    private func checkRescue(with simulatorModel: INVSSimulatorModel, month: Int) -> Double {
        var lastRescue = INVSKeyChainWrapper.retrieveDouble(withKey: INVSConstants.SimulatorConstants.lastRescue.rawValue) ?? simulatorModel.initialMonthlyRescue ?? 0.0
        let increaseRescue = simulatorModel.increaseRescue ?? 0.0
        let nextGoalRescue = INVSKeyChainWrapper.retrieveDouble(withKey: INVSConstants.SimulatorConstants.lastGoalIncreaseRescue.rawValue) ?? simulatorModel.initialValue ?? 0.0
        let lastTotalValueRetrieved = INVSKeyChainWrapper.retrieveDouble(withKey: INVSConstants.SimulatorConstants.lastTotalValue.rawValue) ?? simulatorModel.initialValue ?? 0.0
        
        lastRescue = checkGoalIncreaseRescue(with: simulatorModel, lastTotalValueRetrieved: lastTotalValueRetrieved, nextGoalRescue: nextGoalRescue, lastRescue: lastRescue, increaseRescue: increaseRescue)
        return lastRescue
    }
    
    private func checkGoalIncreaseRescue(with simulatorModel: INVSSimulatorModel, lastTotalValueRetrieved: Double, nextGoalRescue: Double, lastRescue: Double, increaseRescue: Double) -> Double {
        var updatedLastRescue = lastRescue
        var updatedNextGoalRescue = nextGoalRescue
        if let goalIncreaseRescue = simulatorModel.goalIncreaseRescue {
            let _ = INVSKeyChainWrapper.saveDouble(withValue: nextGoalRescue, andKey: INVSConstants.SimulatorConstants.lastGoalIncreaseRescue.rawValue)
            
            if lastTotalValueRetrieved >= nextGoalRescue {
                updatedNextGoalRescue = lastTotalValueRetrieved + (goalIncreaseRescue/(simulatorModel.interestRate/100))
                let _ = INVSKeyChainWrapper.updateDouble(withValue: updatedNextGoalRescue, andKey: INVSConstants.SimulatorConstants.lastGoalIncreaseRescue.rawValue)
                
                updatedLastRescue = updatedLastRescue + increaseRescue
                let _ = INVSKeyChainWrapper.saveDouble(withValue: updatedLastRescue , andKey: INVSConstants.SimulatorConstants.lastRescue.rawValue)
            }
        }
        return updatedLastRescue
    }
}
