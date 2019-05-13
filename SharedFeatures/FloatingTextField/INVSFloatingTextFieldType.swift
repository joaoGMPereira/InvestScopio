//
//  INVSFloatingTextFieldType.swift
//  InvestEx_Example
//
//  Created by Joao Medeiros Pereira on 12/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

enum INVSFloatingTextFieldType: Int {
    
    case none = 0
    case currency
    case percent
    
    
    func formatText(textFieldText: String, isBackSpace: Bool = false) -> String {
        switch self {
        case .none:
            return textFieldText
        case .currency:
            return textFieldText.currencyFormat()
        case .percent:
            return textFieldText.percentFormat(backSpace: isBackSpace)
        }
    }
}
