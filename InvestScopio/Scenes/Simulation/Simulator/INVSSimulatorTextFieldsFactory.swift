//
//  INVSSimulatorTextFieldsFactor.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 26/08/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import UIKit

protocol INVSSimulatorTextFieldsFactoryDelegate: class {
    func routeToInterestRate(textFieldType: INVSFloatingTextFieldType)
}

class INVSSimulatorTextFieldsFactory: NSObject {
    weak var delegate: INVSSimulatorTextFieldsFactoryDelegate?
    func checkTextFieldType(withSelectedTextField textField: INVSFloatingTextField, andAllTextFields textFields: [INVSFloatingTextField]) {
        switch textField.typeTextField {
            case .initialValue:
                break
            case .monthValue:
                break
            case .interestRate:
                textFields.forEach { (textField) in
                    if textField.typeTextField == .totalTimes {
                        if textField.floatingTextField.text != nil && textField.floatingTextField.text != "" {
                            if let delegate = delegate, let type = textField.typeTextField {
                                textField.endEditing(true)
                                delegate.routeToInterestRate(textFieldType: type)
                            }
                        } else {
                            
                        }
                    }
                }
                break
            case .totalTimes:
                break
            case .initialMonthlyRescue:
                break
            case .increaseRescue:
                break
            case .goalIncreaseRescue:
                break
            case .email:
                break
            case .password:
                break
            case .confirmPassword:
                break
            default:
                break
        }
    }
}
