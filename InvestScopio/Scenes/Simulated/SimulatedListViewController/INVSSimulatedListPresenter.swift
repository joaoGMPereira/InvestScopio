//
//  INVSSimulatorPresenter.swift
//  
//
//  Created by Joao Medeiros Pereira on 13/05/19.
//

import Foundation
import UIKit

protocol INVSSimulatedListPresenterProtocol {
    func presentSimulationProjection(simulatorModel: INVSSimulatorModel)
}

class INVSSimulatedListPresenter: NSObject,INVSSimulatedListPresenterProtocol {
    
    weak var controller: INVSSimulatedListViewControlerProtocol?
    
    func presentSimulationProjection(simulatorModel: INVSSimulatorModel) {
        let queue = DispatchQueue(label: "simulation")
        
        queue.async {
            var simulatedValues = [INVSSimulatedValueModel]()
            let totalMonths = simulatorModel.totalMonths
            self.saveInitialProfitabilityUntilNextIncreaseRescue(simulatorModel: simulatorModel)
            simulatedValues.append(self.setInitialValueObject(with: simulatorModel))
            for month in 1...totalMonths {
                let monthValue = simulatorModel.monthValue
                let profitability = self.checkProfitability(with: simulatorModel)
                self.checkTotalValue(with: simulatorModel, profitability: profitability)
                let rescue = self.checkRescue(with: simulatorModel, profitability:profitability, month: month)
                let updatedTotalTotalWithRescue = self.updateTotalValue(withRescue: rescue, simulatorModel: simulatorModel)
                let simulatedValue = INVSSimulatedValueModel(month: month, monthValue: monthValue, profitability: profitability, rescue: rescue, total: updatedTotalTotalWithRescue)
                simulatedValues.append(simulatedValue)
            }
            DispatchQueue.main.async(execute: {
                let shouldShowRescueChart = simulatorModel.initialMonthlyRescue != 0 || simulatorModel.increaseRescue != 0
                self.controller?.displaySimulationProjection(with: simulatedValues, andShouldShowRescueChart: shouldShowRescueChart)
            })
        }
        
    }
}

extension INVSSimulatedListPresenter {
    
    //Salvar primeira rentabilidade
    func saveInitialProfitabilityUntilNextIncreaseRescue(simulatorModel: INVSSimulatorModel) {
        let firstProfitability = (simulatorModel.initialValue * (simulatorModel.interestRate))/100
        let _ = INVSKeyChainWrapper.saveDouble(withValue: firstProfitability, andKey: INVSConstants.SimulatorKeyChainConstants.lastProfitabilityUntilNextIncreaseRescue.rawValue)
    }
    
    //MARK: Mes da Aplicacao Inicial
    private func setInitialValueObject(with simulatorModel: INVSSimulatorModel) -> INVSSimulatedValueModel {
        return INVSSimulatedValueModel(month: nil, monthValue: simulatorModel.monthValue, profitability: nil, rescue: nil, total: simulatorModel.initialValue)
    }
    
    //MARK: Calcular Rendimento
    private func checkProfitability(with simulatorModel: INVSSimulatorModel) -> Double {
        var profitability = 0.0
        var lastTotalValue = getLastTotalValue(with: simulatorModel)
        profitability = (lastTotalValue * (simulatorModel.interestRate))/100
        lastTotalValue = lastTotalValue + profitability

        return profitability
    }
    
    //MARK: Calcular Valor Total Com Rendimento
    private func checkTotalValue(with simulatorModel: INVSSimulatorModel, profitability: Double) {
        let lastTotalValue = getLastTotalValue(with: simulatorModel)
        let totalValueUpdated = lastTotalValue + profitability + (simulatorModel.monthValue)
        let _ = INVSKeyChainWrapper.updateDouble(withValue: totalValueUpdated, andKey: INVSConstants.SimulatorKeyChainConstants.lastTotalValue.rawValue)
    }
    
    //MARK: Salvar o valor Inicial e pegar o valor atualizado
    private func getLastTotalValue(with simulatorModel: INVSSimulatorModel) -> Double {
        var lastTotalValue = simulatorModel.initialValue
        if let lastTotalValueRetrieved = INVSKeyChainWrapper.retrieveDouble(withKey: INVSConstants.SimulatorKeyChainConstants.lastTotalValue.rawValue) {
            lastTotalValue = lastTotalValueRetrieved
        } else {
            let _ = INVSKeyChainWrapper.saveDouble(withValue: lastTotalValue, andKey: INVSConstants.SimulatorKeyChainConstants.lastTotalValue.rawValue)
        }
        return lastTotalValue
    }
    
    //MARK: Verificar proximo resgate
    private func checkRescue(with simulatorModel: INVSSimulatorModel, profitability: Double, month: Int) -> Double {
        var lastRescue = INVSKeyChainWrapper.retrieveDouble(withKey: INVSConstants.SimulatorKeyChainConstants.lastRescue.rawValue) ?? simulatorModel.initialMonthlyRescue
        
        let lastProfitabilityUntilNextIncreaseRescue = INVSKeyChainWrapper.retrieveDouble(withKey: INVSConstants.SimulatorKeyChainConstants.lastProfitabilityUntilNextIncreaseRescue.rawValue) ?? 0
        let lastTotalValueRetrieved = INVSKeyChainWrapper.retrieveDouble(withKey: INVSConstants.SimulatorKeyChainConstants.lastTotalValue.rawValue) ?? simulatorModel.initialValue
        
        lastRescue = checkGoalIncreaseRescue(with: simulatorModel, profitability: profitability, lastTotalValueRetrieved: lastTotalValueRetrieved, lastProfitabilityUntilNextIncreaseRescue: lastProfitabilityUntilNextIncreaseRescue, lastRescue: lastRescue, month: month)
        return lastRescue
    }
    
    //MARK: Verificar objetivo de regaste
    private func checkGoalIncreaseRescue(with simulatorModel: INVSSimulatorModel, profitability: Double, lastTotalValueRetrieved: Double, lastProfitabilityUntilNextIncreaseRescue: Double, lastRescue: Double, month: Int) -> Double {
        var increaseRescue = simulatorModel.increaseRescue
        var updatedLastRescue = lastRescue
        let lastProfitabilityUntilNextIncreaseRescue = lastProfitabilityUntilNextIncreaseRescue
        let goalIncreaseRescue = simulatorModel.goalIncreaseRescue
        
        if let nextRescueIsHigherThanProfitability = checkIfRescueIsHigherThanProfitability(rescue: lastRescue, profitability: profitability) {
            updatedLastRescue = nextRescueIsHigherThanProfitability
            return updatedLastRescue
        }
        
        if let nextRescueWithoutGoal = checkNextGoalRescueWithoutGoalIncreaseRescue(rescue: updatedLastRescue, increaseRescue: increaseRescue, goalIncreaseRescue: goalIncreaseRescue, month: month) {
            updatedLastRescue = nextRescueWithoutGoal
            return updatedLastRescue
        }
        var multiplierGoalIncreaseRescue = Int((profitability - lastProfitabilityUntilNextIncreaseRescue)/goalIncreaseRescue)
        if multiplierGoalIncreaseRescue < 1 {
            multiplierGoalIncreaseRescue = 1
        }
        let nextGoalRescue = lastProfitabilityUntilNextIncreaseRescue + (goalIncreaseRescue * Double(multiplierGoalIncreaseRescue))
        increaseRescue = increaseRescue * Double(multiplierGoalIncreaseRescue)
        if profitability >= nextGoalRescue {
            updatedLastRescue = checkIfNextRescueWillBeBiggerThanProfitability(withUpdatedLastRescue: updatedLastRescue, increaseRescue: increaseRescue, profitability: profitability, nextGoalRescue: nextGoalRescue)
        }
        
        return updatedLastRescue
    }
    
    //MARK: Verificar se o proximo resgate vai ser maior que a rentabilidade
    func checkIfNextRescueWillBeBiggerThanProfitability(withUpdatedLastRescue updatedLastRescue: Double, increaseRescue: Double, profitability: Double, nextGoalRescue: Double) -> Double {
        var updatedLastRescue = updatedLastRescue
        let updatedLastRescueWithIncreaseRescue = updatedLastRescue + increaseRescue
        if updatedLastRescueWithIncreaseRescue < profitability {
            let _ = INVSKeyChainWrapper.updateDouble(withValue: nextGoalRescue, andKey: INVSConstants.SimulatorKeyChainConstants.lastProfitabilityUntilNextIncreaseRescue.rawValue)
            updatedLastRescue = updatedLastRescueWithIncreaseRescue
            let _ = INVSKeyChainWrapper.updateDouble(withValue: updatedLastRescue , andKey: INVSConstants.SimulatorKeyChainConstants.lastRescue.rawValue)
        }
        return updatedLastRescue
    }
    
    //MARK: Verificar proximo resgate sem proximo objetivo
    private func checkIfRescueIsHigherThanProfitability(rescue: Double, profitability: Double) -> Double? {
        if rescue > profitability {
            let _ = INVSKeyChainWrapper.saveDouble(withValue: rescue, andKey: INVSConstants.SimulatorKeyChainConstants.lastRescue.rawValue)
            return 0.0
        }
        return nil
    }
    
    //MARK: Verificar proximo resgate sem proximo objetivo
    private func checkNextGoalRescueWithoutGoalIncreaseRescue(rescue: Double, increaseRescue: Double, goalIncreaseRescue: Double, month: Int) -> Double? {
        if goalIncreaseRescue == 0 {
            var nextGoalRescue = rescue
            if month != 1 {
               nextGoalRescue += increaseRescue
            }
            let _ = INVSKeyChainWrapper.saveDouble(withValue: nextGoalRescue, andKey: INVSConstants.SimulatorKeyChainConstants.lastRescue.rawValue)
            return nextGoalRescue
        }
        return nil
    }
    
    //MARK: atualizar valor total com o resgate
    private func updateTotalValue(withRescue rescue: Double, simulatorModel: INVSSimulatorModel) -> Double {
        var lastTotalValueRetrieved = INVSKeyChainWrapper.retrieveDouble(withKey: INVSConstants.SimulatorKeyChainConstants.lastTotalValue.rawValue) ?? simulatorModel.initialValue
        lastTotalValueRetrieved = lastTotalValueRetrieved - rescue
        let _ = INVSKeyChainWrapper.updateDouble(withValue: lastTotalValueRetrieved, andKey: INVSConstants.SimulatorKeyChainConstants.lastTotalValue.rawValue)
        return lastTotalValueRetrieved
    }
}
