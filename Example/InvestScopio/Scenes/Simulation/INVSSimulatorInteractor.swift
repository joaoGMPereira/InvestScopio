//
//  INVSSimutatorInteractor.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 13/05/19.
//

import Foundation
import UIKit
protocol INVSSimulatorInteractorProtocol {
    func simulationProjection()
    func showInfo(nearOfSender sender:UIView)
    func checkToolbarAction(withTextField textField:INVSFloatingTextField, typeOfAction type: INVSKeyboardToolbarButton)
    func clear()
}

class INVSSimulatorInteractor: NSObject,INVSSimulatorInteractorProtocol {
    
    var presenter: INVSSimulatorPresenterProtocol?
    var worker: INVSSimulatorWorkerProtocol = INVSSimulatorWorker()
    var allTextFields = [INVSFloatingTextField]()
    
    func simulationProjection() {
        INVSKeyChainWrapper.clear()
        worker.simulationProjection(with: allTextFields, successCompletionHandler: { (simulatorModel) in
            self.presenter?.presentSimulationProjection(simulatorModel: simulatorModel)
        }) { (messageError) in
            self.presenter?.presentErrorSimulationProjection(with: messageError)
        }
    }
    
    func checkToolbarAction(withTextField textField: INVSFloatingTextField, typeOfAction type: INVSKeyboardToolbarButton) {
        presenter?.presentToolbarAction(withPreviousTextField: textField, allTextFields: allTextFields, typeOfAction: type)
    }
    
    func showInfo(nearOfSender sender: UIView) {
        presenter?.presentInfo(sender: sender)
    }
    
    func clear() {
        INVSKeyChainWrapper.clear()
        for textField in allTextFields {
            textField.clear()
        }
        presenter?.presentClear()
    }
    
}
