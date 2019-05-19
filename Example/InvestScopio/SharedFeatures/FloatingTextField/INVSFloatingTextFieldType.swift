//
//  INVSFloatingTextFieldType.swift
//  InvestScopio_Example
//
//  Created by Joao Medeiros Pereira on 13/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

enum INVSFloatingTextFieldType: Int {
    
    case initialValue = 0
    case monthValue
    case interestRate
    case totalMonths
    case initialMonthlyRescue
    case increaseRescue
    case goalIncreaseRescue
    
    
    func getMessageInfo() -> String {
        switch self {
        case .initialValue:
        return ""
        case .monthValue:
        return ""
        case .interestRate:
        return ""
        case .totalMonths:
        return ""
        case .initialMonthlyRescue:
        return "É o valor inicial para começar o resgate do seu rendimento.\n Ex: Seu rendimento está em 10R$ e decide retirar 1R$, portanto nesse mês você terá como resultado:\nRendimento: 9R$\nResgate: 1R$"
        case .increaseRescue:
        return ""
        case .goalIncreaseRescue:
        return ""
        }
    }
    
    func getNext(allTextFields: [INVSFloatingTextField]) -> INVSFloatingTextField? {
        return allTextFields.filter({$0.typeTextField == self.next()}).first
    }
    
    private func next() -> INVSFloatingTextFieldType? {
        return INVSFloatingTextFieldType(rawValue: rawValue + 1)
    }
}
