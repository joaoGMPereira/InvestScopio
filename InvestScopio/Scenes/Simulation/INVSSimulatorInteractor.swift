//
//  INVSSimutatorInteractor.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 13/05/19.
//

import Foundation
import UIKit
protocol INVSSimulatorInteractorProtocol {
    func check(withTextFields textFields: [INVSFloatingTextField])
    func review(withTextFields textFields: [INVSFloatingTextField])
    func simulationProjection()
    func simulateSteps(withTextFields textFields: [INVSFloatingTextField])
    func showInfo(withSender sender:UIView)
    func checkToolbarAction(withTextField textField:INVSFloatingTextField, typeOfAction type: INVSKeyboardToolbarButton)
    func clear()
    
    var allTextFields: [INVSFloatingTextField] { get }
}

class INVSSimulatorInteractor: NSObject,INVSSimulatorInteractorProtocol {
    
    var presenter: INVSSimulatorPresenterProtocol?
    var worker: INVSSimulatorWorkerProtocol = INVSSimulatorWorker()
    var allTextFields = [INVSFloatingTextField]()
    
    func check(withTextFields textFields: [INVSFloatingTextField]) {
        worker.checkIfTextFieldIsRequired(with: textFields, successCompletionHandler: { (finished) in
            if let lastTextField = textFields.last {
                self.presenter?.presentNextTextField(withLastTextField: lastTextField)
            }
        }) { (messageError, shouldHideAutomatically, popupType) in
            self.presenter?.presentError(with: messageError, shouldHideAutomatically: shouldHideAutomatically, popupType: popupType, sender: nil)
        }
    }
    
    func simulateSteps(withTextFields textFields: [INVSFloatingTextField]) {
        review(withTextFields: textFields)
        simulationProjection()
    }
    
    func review(withTextFields textFields: [INVSFloatingTextField]) {
        presenter?.presentReview(withTextFields: textFields)
    }
    
    func simulationProjection() {
        worker.simulationProjection(with: allTextFields, successCompletionHandler: { (simulatorModel) in
            self.presenter?.presentSimulationProjection(simulatorModel: simulatorModel)
        }) { (messageError, shouldHideAutomatically, popupType)  in
            self.presenter?.presentError(with: messageError, shouldHideAutomatically: shouldHideAutomatically, popupType: popupType, sender: nil)
        }
    }
    
    func checkToolbarAction(withTextField textField: INVSFloatingTextField, typeOfAction type: INVSKeyboardToolbarButton) {
        presenter?.presentToolbarAction(withPreviousTextField: textField, allTextFields: allTextFields, typeOfAction: type)
    }
    
    func showInfo(withSender sender: UIView) {
        presenter?.presentInfo(sender: sender)
    }
    
    func clear() {
        INVSKeyChainWrapper.clear()
        for textField in allTextFields {
            textField.clear()
        }
    }
    
}
