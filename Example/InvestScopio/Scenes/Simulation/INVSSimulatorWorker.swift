//
//  INVSSimulatorWorker.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 13/05/19.
//

import Foundation

typealias SuccessSimulationHandler = (INVSSimulatorModel) -> Void
typealias ErrorSimulationHandler = (_ messageError:String) ->()

protocol INVSSimulatorWorkerProtocol {
    func simulationProjection(with textFields: [INVSFloatingTextField], successCompletionHandler: @escaping(SuccessSimulationHandler), errorCompletionHandler:@escaping(ErrorSimulationHandler))
}

class INVSSimulatorWorker: NSObject,INVSSimulatorWorkerProtocol {
    func simulationProjection(with textFields: [INVSFloatingTextField], successCompletionHandler: @escaping (SuccessSimulationHandler), errorCompletionHandler: @escaping (ErrorSimulationHandler)) {
        DispatchQueue.main.async {
            let allTextFieldsRequired = textFields.filter({$0.required == true})
            var areFieldsRequiredFilled = true
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
            
            areFieldsRequiredFilled == true ? successCompletionHandler(self.populateSimulatorModel(with: textFields)) : errorCompletionHandler("Preencha todos os campos obrigatórios!")
        }
    }
    
    private func populateSimulatorModel(with textFields:[INVSFloatingTextField]) -> INVSSimulatorModel {
        var simulatorModel = INVSSimulatorModel()
        for textField in textFields {
            if let typeTextField = textField.typeTextField {
                switch typeTextField {
                case .initialValue:
                    simulatorModel.initialValue = textField.floatingTextField.text?.convertFormattedToDouble()
                case .monthValue:
                    simulatorModel.monthValue = textField.floatingTextField.text?.convertFormattedToDouble()
                case .interestRate:
                    simulatorModel.interestRate = textField.floatingTextField.text?.convertFormattedToDouble()
                case .totalMonths:
                    simulatorModel.totalMonths = Int(textField.floatingTextField.text ?? "0")
                case .initialMonthlyRescue:
                    simulatorModel.initialMonthlyRescue = textField.floatingTextField.text?.convertFormattedToDouble()
                case .increaseRescue:
                    simulatorModel.increaseRescue = textField.floatingTextField.text?.convertFormattedToDouble()
                case .goalIncreaseRescue:
                    simulatorModel.goalIncreaseRescue = textField.floatingTextField.text?.convertFormattedToDouble()
                }
            }
        }
        return simulatorModel
    }
    
}
