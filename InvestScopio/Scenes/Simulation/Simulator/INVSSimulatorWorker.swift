//
//  INVSSimulatorWorker.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 13/05/19.
//

import Foundation
import UIKit
typealias SuccessSimulationHandler = (INVSSimulatorModel) -> Void
typealias SuccessCheckTextFieldHandler = (Bool) -> Void
typealias ErrorHandler = (_ messageError:String, _ shouldHideAutomatically:Bool, _ popupType:INVSPopupMessageType) ->()
typealias CheckIfIncreaseRescueTextFieldIsRequiredHandler = (_ increaseRescueTextField:INVSFloatingTextField?, _ goalIncreaseRescueTextField:INVSFloatingTextField?, _ increaseRescueTextFieldIsRequired: Bool, _ messageError: String) ->()

protocol INVSSimulatorWorkerProtocol {
    func simulationProjection(with textFields: [INVSFloatingTextField], successCompletionHandler: @escaping(SuccessSimulationHandler), errorCompletionHandler:@escaping(ErrorHandler))
    
    func checkIfTextFieldIsRequired(with textFields: [INVSFloatingTextField], successCompletionHandler: @escaping(SuccessCheckTextFieldHandler), errorCompletionHandler:@escaping(ErrorHandler))
}

class INVSSimulatorWorker: NSObject,INVSSimulatorWorkerProtocol {
    func checkIfTextFieldIsRequired(with textFields: [INVSFloatingTextField], successCompletionHandler: @escaping (SuccessCheckTextFieldHandler), errorCompletionHandler: @escaping (ErrorHandler)) {
        let allTextFieldsRequired = textFields.filter({$0.required == true})
        var areFieldsRequiredFilled = true
        self.checkIfIncreaseRescueTextFieldIsRequired(withAllTextFields: textFields, handler: { (increaseRescueTextField, goalIncreaseRescueTextField, increaseRescueTextFieldIsRequired, messageError) in
            for textField in allTextFieldsRequired {
                let valueText = textField.floatingTextField.text
                textField.hasError = false
                if valueText == "" || valueText == nil {
                    textField.hasError = true
                    areFieldsRequiredFilled = false
                }
            }
            if let firstTextFieldWithError = allTextFieldsRequired.filter({$0.hasError}).first {
                firstTextFieldWithError.floatingTextField.becomeFirstResponder()
            }
            
            if areFieldsRequiredFilled {
                if increaseRescueTextFieldIsRequired == true {
                    errorCompletionHandler(messageError, false, .error)
                    return
                }
                
                if let totalMonthsTextField = textFields.filter({$0.typeTextField == INVSFloatingTextFieldType.totalMonths}).first {
                    if totalMonthsTextField.floatingTextField.text == "0" {
                        totalMonthsTextField.hasError = true
                        errorCompletionHandler("O total de meses tem que ser maior que 0!", true, .error)
                        return
                    }
                }
                
                successCompletionHandler(true)
                return
            }
            errorCompletionHandler("Preencha todos os campos obrigatórios!", true, .error)
            
        })
    }
    
    func simulationProjection(with textFields: [INVSFloatingTextField], successCompletionHandler: @escaping (SuccessSimulationHandler), errorCompletionHandler: @escaping (ErrorHandler)) {
        checkIfTextFieldIsRequired(with: textFields, successCompletionHandler: { (finished) in
            successCompletionHandler(self.populateSimulatorModel(with: textFields))
        }) { (messageError, shouldHideAutomatically, popupType) in
            errorCompletionHandler(messageError, shouldHideAutomatically, popupType)
        }
    }
    
    func checkIfIncreaseRescueTextFieldIsRequired(withAllTextFields textFields: [INVSFloatingTextField], handler: CheckIfIncreaseRescueTextFieldIsRequiredHandler) {
        if let goalIncreaseRescueTextField = textFields.filter({$0.typeTextField == INVSFloatingTextFieldType.goalIncreaseRescue}).first {
            if let increaseRescueTextField = textFields.filter({$0.typeTextField == INVSFloatingTextFieldType.increaseRescue}).first {
                checkGoalIncreaseRescueTextFieldValue(increaseRescueTextField: increaseRescueTextField, goalIncreaseRescueTextField: goalIncreaseRescueTextField, handler: handler)
            }
            return
        }
        handler(nil,nil,false, "")
    }
    
    private func checkGoalIncreaseRescueTextFieldValue(increaseRescueTextField: INVSFloatingTextField, goalIncreaseRescueTextField: INVSFloatingTextField, handler: CheckIfIncreaseRescueTextFieldIsRequiredHandler) {
        let goalIncreaseRescueValue = goalIncreaseRescueTextField.floatingTextField.text?.convertFormattedToDouble() ?? 0
        let increaseRescueValue = increaseRescueTextField.floatingTextField.text?.convertFormattedToDouble() ?? 0
        let goalIncreaseRescueText = goalIncreaseRescueTextField.placeholderLabel.text?.replacingOccurrences(of: "*", with: "") ?? ""
        let increaseRescueText = increaseRescueTextField.placeholderLabel.text?.replacingOccurrences(of: "*", with: "") ?? ""
        
        if goalIncreaseRescueTextField.floatingTextField.text != "" {
            if increaseRescueTextField.floatingTextField.text?.convertFormattedToDouble() != 0 {
                if goalIncreaseRescueValue < increaseRescueValue {
                    increaseRescueTextField.hasError = true
                    goalIncreaseRescueTextField.hasError = true
                    goalIncreaseRescueTextField.floatingTextField.becomeFirstResponder()
                    handler(increaseRescueTextField,goalIncreaseRescueTextField,true, "É necessário que o valor do \(goalIncreaseRescueText) seja maior ou igual ao valor do \(increaseRescueText)")
                    return
                }
                increaseRescueTextField.hasError = false
                increaseRescueTextField.floatingTextField.resignFirstResponder()
                handler(increaseRescueTextField,goalIncreaseRescueTextField,false, "")
                return
            }
            increaseRescueTextField.hasError = true
            increaseRescueTextField.floatingTextField.becomeFirstResponder()
            handler(increaseRescueTextField,goalIncreaseRescueTextField,true, "É necessário que o valor do campo:\(goalIncreaseRescueText) seja maior ou igual ao valor do campo: \(increaseRescueText)")
            return
        }
        handler(increaseRescueTextField,goalIncreaseRescueTextField,false, "")
    }
    
    private func populateSimulatorModel(with textFields:[INVSFloatingTextField]) -> INVSSimulatorModel {
        var simulatorModel = INVSSimulatorModel()
        for textField in textFields {
            if let typeTextField = textField.typeTextField {
                switch typeTextField {
                case .initialValue:
                    simulatorModel.initialValue = textField.floatingTextField.text?.convertFormattedToDouble() ?? 0.0
                case .monthValue:
                    simulatorModel.monthValue = textField.floatingTextField.text?.convertFormattedToDouble() ?? 0.0
                case .interestRate:
                    simulatorModel.interestRate = textField.floatingTextField.text?.convertFormattedToDouble() ?? 0.0
                case .totalMonths:
                    simulatorModel.totalMonths = Int(textField.floatingTextField.text ?? "0") ?? 0
                case .initialMonthlyRescue:
                    simulatorModel.initialMonthlyRescue = textField.floatingTextField.text?.convertFormattedToDouble() ?? 0.0
                case .increaseRescue:
                    simulatorModel.increaseRescue = textField.floatingTextField.text?.convertFormattedToDouble() ?? 0.0
                case .goalIncreaseRescue:
                    simulatorModel.goalIncreaseRescue = textField.floatingTextField.text?.convertFormattedToDouble() ?? 0.0
                case .email:
                    break
                case .password:
                    break
                case .confirmPassword:
                    break
                    
                }
            }
        }
        return simulatorModel
    }
    
}
