//
//  INVSSimulatorWorker.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 13/05/19.
//

import Foundation
import UIKit
typealias SuccessSimulationHandler = (INVSSimulatorModel) -> Void
typealias ErrorSimulationHandler = (_ messageError:String, _ shouldHideAutomatically:Bool, _ popupType:INVSPopupMessageType, _ sender: UIView?) ->()

protocol INVSSimulatorWorkerProtocol {
    func simulationProjection(with textFields: [INVSFloatingTextField], successCompletionHandler: @escaping(SuccessSimulationHandler), errorCompletionHandler:@escaping(ErrorSimulationHandler))
}

class INVSSimulatorWorker: NSObject,INVSSimulatorWorkerProtocol {
    func simulationProjection(with textFields: [INVSFloatingTextField], successCompletionHandler: @escaping (SuccessSimulationHandler), errorCompletionHandler: @escaping (ErrorSimulationHandler)) {
        DispatchQueue.main.async {
            let allTextFieldsRequired = textFields.filter({$0.required == true})
            var areFieldsRequiredFilled = true
            if let increaseRescueTextField = self.checkIfIncreaseRescueTextFieldIsRequired(withAllTextFields: textFields) {
                errorCompletionHandler("Estipulando um valor no campo: Valor para aumentar o Resgate, é necessário o preenchimento do campo: Aumento no Resgate", false, .error, increaseRescueTextField)
                return
            }
            
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
            
            areFieldsRequiredFilled == true ? successCompletionHandler(self.populateSimulatorModel(with: textFields)) : errorCompletionHandler("Preencha todos os campos obrigatórios!", true, .error, nil)
        }
    }
    
    func checkIfIncreaseRescueTextFieldIsRequired(withAllTextFields textFields: [INVSFloatingTextField]) -> INVSFloatingTextField? {
        if let goalIncreaseRescueTextField = textFields.filter({$0.typeTextField == INVSFloatingTextFieldType.goalIncreaseRescue}).first {
            if goalIncreaseRescueTextField.floatingTextField.text != "" {
                if let increaseRescueTextField = textFields.filter({$0.typeTextField == INVSFloatingTextFieldType.increaseRescue}).first {
                    if increaseRescueTextField.floatingTextField.text?.convertFormattedToDouble() != 0 {
                        increaseRescueTextField.hasError = false
                        increaseRescueTextField.floatingTextField.resignFirstResponder()
                        return nil
                    }
                    increaseRescueTextField.hasError = true
                    increaseRescueTextField.floatingTextField.becomeFirstResponder()
                    return increaseRescueTextField
                }
            }
        }
        return nil
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
                }
            }
        }
        return simulatorModel
    }
    
}
