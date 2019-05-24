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
    func presentErrorSimulationProjection(with messageError:String, shouldHideAutomatically:Bool, popupType: INVSPopupMessageType, sender: UIView?)
    func presentInfo(sender: UIView)
    func presentToolbarAction(withPreviousTextField textField:INVSFloatingTextField, allTextFields textFields:[INVSFloatingTextField], typeOfAction type: INVSKeyboardToolbarButton)
}

class INVSSimulatorPresenter: NSObject,INVSSimulatorPresenterProtocol {
    
    weak var controller: INVSSimutatorViewControlerProtocol?
    
    func presentSimulationProjection(simulatorModel: INVSSimulatorModel) {
        controller?.displaySimulationProjection(with: simulatorModel)
    }
    
    func presentErrorSimulationProjection(with messageError:String, shouldHideAutomatically:Bool, popupType: INVSPopupMessageType, sender: UIView?) {
        controller?.displayErrorSimulationProjection(with: messageError, shouldHideAutomatically: shouldHideAutomatically, popupType: popupType, sender: sender)
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
        if let textField = sender as? INVSFloatingTextField {
            controller?.displayInfo(withMessage: textField.typeTextField?.getMessageInfo() ?? "", title: textField.typeTextField?.getTitleMessageInfo() ?? "", shouldHideAutomatically: false, sender: sender)
        }
    }
}
