//
//  JGFloatingTextFieldFactory.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 19/10/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import UIKit

class JGFloatingTextFieldFactory: NSObject {
    static func setup(withFloatingTextField textField: JGFloatingTextField) {
        textField.setup(placeholder: "teste", typeTextField: .totalTimes, valueTypeTextField: .currency, keyboardType: .numberPad, required: true, hasInfoButton: true, color: UIColor.INVSDefault(), shouldShowKeyboard: true)
        let codeViewBuilder = JGFloatingTextFieldCodeViewBuilder.init(with: textField)
        codeViewBuilder.setupBuilder()
    }
}
