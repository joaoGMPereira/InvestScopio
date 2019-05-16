//
//  INVSSimulatorPresenter.swift
//  
//
//  Created by Joao Medeiros Pereira on 13/05/19.
//

import Foundation
import UIKit

protocol INVSSimulatorPresenterProtocol {
    func presentSimulationProjection(simulatorModel: INVSSimulatorModel)
    func presentErrorSimulationProjection(with messageError:String)
    func presentInfo(sender: UIView)
    func presentToolbarAction(withPreviousTextField textField:INVSFloatingTextField, allTextFields textFields:[INVSFloatingTextField], typeOfAction type: INVSKeyboardToolbarButton)
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
    func presentToolbarAction(withPreviousTextField textField: INVSFloatingTextField, allTextFields textFields: [INVSFloatingTextField], typeOfAction type: INVSKeyboardToolbarButton) {
        switch type {
        case .cancel:
            controller?.displayCancelAction()
        case .ok:
            let nextTextField = textField.typeTextField?.getNext(allTextFields: textFields)
            controller?.displayOkAction(withTextField: nextTextField ?? textField, andShouldResign: nextTextField == nil)
        }
        
    }
    
    func presentInfo(sender: UIView) {
        controller?.displayInfo(withMessage: "Seu valor de retirada irá aumentar até que a proxima meta seja igual ou maior que seu valor total.", shouldHideAutomatically: false, sender: sender)
    }
    
    func presentClear() {
         controller?.displayClear()
    }
    
}

extension INVSSimulatorPresenter {
    
    private func setInitialValueObject(with simulatorModel: INVSSimulatorModel) -> INVSSimulatedValueModel {
        return INVSSimulatedValueModel(month: nil, monthValue: simulatorModel.monthValue, profitability: nil, rescue: nil, total: simulatorModel.initialValue)
    }
    
    private func updateTotalValue(withRescue rescue: Double, simulatorModel: INVSSimulatorModel) -> Double {
        var lastTotalValueRetrieved = INVSKeyChainWrapper.retrieveDouble(withKey: INVSConstants.SimulatorKeyChainConstants.lastTotalValue.rawValue) ?? simulatorModel.initialValue ?? 0.0
        lastTotalValueRetrieved = lastTotalValueRetrieved - rescue
        let _ = INVSKeyChainWrapper.updateDouble(withValue: lastTotalValueRetrieved, andKey: INVSConstants.SimulatorKeyChainConstants.lastTotalValue.rawValue)
        return lastTotalValueRetrieved
    }
    
    private func checkProfitability(with simulatorModel: INVSSimulatorModel, month: Int) -> Double {
        var lastTotalValue = simulatorModel.initialValue ?? 0
        var profitability = 0.0
        lastTotalValue = checkTotalValue(with: lastTotalValue)
        profitability = lastTotalValue * ((simulatorModel.interestRate ?? 0.0)/100)
        lastTotalValue = lastTotalValue + profitability
        let _ = INVSKeyChainWrapper.updateDouble(withValue: lastTotalValue, andKey: INVSConstants.SimulatorKeyChainConstants.lastTotalValue.rawValue)
        
        return profitability
    }
    
    private func checkTotalValue(with totalValue: Double) -> Double {
        var lastTotalValue = totalValue
        if let lastTotalValueRetrieved = INVSKeyChainWrapper.retrieveDouble(withKey: INVSConstants.SimulatorKeyChainConstants.lastTotalValue.rawValue) {
            lastTotalValue = lastTotalValueRetrieved
        } else {
            let _ = INVSKeyChainWrapper.saveDouble(withValue: lastTotalValue, andKey: INVSConstants.SimulatorKeyChainConstants.lastTotalValue.rawValue)
        }
        return lastTotalValue
    }
    
    private func checkRescue(with simulatorModel: INVSSimulatorModel, month: Int) -> Double {
        var lastRescue = INVSKeyChainWrapper.retrieveDouble(withKey: INVSConstants.SimulatorKeyChainConstants.lastRescue.rawValue) ?? simulatorModel.initialMonthlyRescue ?? 0.0
        let increaseRescue = simulatorModel.increaseRescue ?? 0.0
        let nextGoalRescue = INVSKeyChainWrapper.retrieveDouble(withKey: INVSConstants.SimulatorKeyChainConstants.lastGoalIncreaseRescue.rawValue) ?? simulatorModel.initialValue ?? 0.0
        let lastTotalValueRetrieved = INVSKeyChainWrapper.retrieveDouble(withKey: INVSConstants.SimulatorKeyChainConstants.lastTotalValue.rawValue) ?? simulatorModel.initialValue ?? 0.0
        
        lastRescue = checkGoalIncreaseRescue(with: simulatorModel, lastTotalValueRetrieved: lastTotalValueRetrieved, nextGoalRescue: nextGoalRescue, lastRescue: lastRescue, increaseRescue: increaseRescue)
        return lastRescue
    }
    
    private func checkGoalIncreaseRescue(with simulatorModel: INVSSimulatorModel, lastTotalValueRetrieved: Double, nextGoalRescue: Double, lastRescue: Double, increaseRescue: Double) -> Double {
        var updatedLastRescue = lastRescue
        var updatedNextGoalRescue = nextGoalRescue
        if let goalIncreaseRescue = simulatorModel.goalIncreaseRescue {
            let _ = INVSKeyChainWrapper.saveDouble(withValue: nextGoalRescue, andKey: INVSConstants.SimulatorKeyChainConstants.lastGoalIncreaseRescue.rawValue)
            
            if lastTotalValueRetrieved >= nextGoalRescue {
                updatedNextGoalRescue = lastTotalValueRetrieved + (goalIncreaseRescue/(simulatorModel.interestRate/100))
                let _ = INVSKeyChainWrapper.updateDouble(withValue: updatedNextGoalRescue, andKey: INVSConstants.SimulatorKeyChainConstants.lastGoalIncreaseRescue.rawValue)
                
                updatedLastRescue = updatedLastRescue + increaseRescue
                let _ = INVSKeyChainWrapper.saveDouble(withValue: updatedLastRescue , andKey: INVSConstants.SimulatorKeyChainConstants.lastRescue.rawValue)
            }
        }
        return updatedLastRescue
    }
}
