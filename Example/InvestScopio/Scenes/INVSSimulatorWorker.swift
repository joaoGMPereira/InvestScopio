//
//  INVSSimulatorWorker.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 13/05/19.
//

import Foundation

typealias SuccessSimulationHandler = (Bool) -> Void
typealias ErrorSimulationHandler = (_ messageError:String) ->()

protocol INVSSimulatorWorkerProtocol {
    func simulationProjection(with textFields: [INVSFloatingTextField], successCompletionHandler: @escaping(SuccessSimulationHandler), errorCompletionHandler:@escaping(ErrorSimulationHandler))
}

class INVSSimulatorWorker: NSObject,INVSSimulatorWorkerProtocol {
    func simulationProjection(with textFields: [INVSFloatingTextField], successCompletionHandler: @escaping (SuccessSimulationHandler), errorCompletionHandler: @escaping (ErrorSimulationHandler)) {
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
        allTextFieldsRequired.filter({$0.hasError}).first?.floatingTextField.becomeFirstResponder()
        areFieldsRequiredFilled == true ? successCompletionHandler(true) : errorCompletionHandler("Preencha todos os campos obrigatórios!")
        
    }
    
}
