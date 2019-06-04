//
//  INVSSimulatorPresenter.swift
//  
//
//  Created by Joao Medeiros Pereira on 13/05/19.
//

import Foundation
import UIKit

protocol INVSSimulatorPresenterProtocol {
    func presentNextTextField(withLastTextField textField: INVSFloatingTextField)
    func presentReview(withTextFields textFields: [INVSFloatingTextField])
    func presentSimulationProjection(simulatorModel: INVSSimulatorModel)
    func presentError(with messageError:String, shouldHideAutomatically:Bool, popupType: INVSPopupMessageType, sender: UIView?)
    func presentInfo(sender: UIView)
    func presentToolbarAction(withPreviousTextField textField:INVSFloatingTextField, allTextFields textFields:[INVSFloatingTextField], typeOfAction type: INVSKeyboardToolbarButton)
}

class INVSSimulatorPresenter: NSObject,INVSSimulatorPresenterProtocol {
    
    weak var controller: INVSSimutatorViewControlerProtocol?
    
    func presentNextTextField(withLastTextField textField: INVSFloatingTextField) {
        controller?.displayNextTextField(withLastTextField: textField)
    }
    
    func presentReview(withTextFields textFields: [INVSFloatingTextField]) {
        controller?.displayReview(withTextFields: textFields)
    }
    
    func presentSimulationProjection(simulatorModel: INVSSimulatorModel) {
        controller?.displaySimulationProjection(with: simulatorModel)
    }
    
    func presentError(with messageError:String, shouldHideAutomatically:Bool, popupType: INVSPopupMessageType, sender: UIView?) {
        controller?.displayErrorSimulationProjection(with: messageError, shouldHideAutomatically: shouldHideAutomatically, popupType: popupType, sender: sender)
    }
    func presentToolbarAction(withPreviousTextField textField: INVSFloatingTextField, allTextFields textFields: [INVSFloatingTextField], typeOfAction type: INVSKeyboardToolbarButton) {
        switch type {
        case .back:
            break
        case .cancel:
            controller?.displayCancelAction()
        case .ok:
            let nextTextField = textField.typeTextField?.getNext(allTextFields: textFields)
            controller?.displayOkAction(withTextField: nextTextField ?? textField, andShouldResign: nextTextField == nil)
        }
        
    }
    
    func presentInfo(sender: UIView) {
        if let textField = sender as? INVSFloatingTextField {
            controller?.displayInfo(withMessage: textField.typeTextField?.getMessageInfo() ?? "", title: textField.typeTextField?.getTitleMessageInfo() ?? "", shouldHideAutomatically: false)
        }
    }
}
