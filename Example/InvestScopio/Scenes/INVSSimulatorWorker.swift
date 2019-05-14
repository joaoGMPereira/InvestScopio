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
        if let firstTextFieldWithError = allTextFieldsRequired.filter({$0.hasError}).first {
            firstTextFieldWithError.floatingTextField.becomeFirstResponder()
        }
       // let simulatorModel = INVSSimulatorModel(initialValue: <#T##Double#>, monthValue: <#T##Double#>, interestRate: <#T##Double#>, monthlyRescue: <#T##Double?#>, increaseRescue: <#T##Double?#>, goalIncreaseRescue: <#T##Double?#>)
        populateSimulatorModel(with: textFields)
        areFieldsRequiredFilled == true ? successCompletionHandler(true) : errorCompletionHandler("Preencha todos os campos obrigatórios!")
        
    }
    
    private func populateSimulatorModel(with textFields:[INVSFloatingTextField]) {
        
        let bookMirror = Mirror(reflecting: textFields)
        for (name, value) in bookMirror.children {
            guard let name = name else { continue }
            print("\(name): \(type(of: value)) = '\(value)'")
        }
    }
    
}
