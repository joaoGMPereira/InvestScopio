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
        return "É o valor inicial para começar o resgate do seu rendimento.\n\nExemplo: Seu rendimento está em 10R$ e decide retirar 1R$, portanto nesse mês você terá como resultado:\nRendimento: 9R$ Resgate: 1R$"
        case .increaseRescue:
            return "Exemplos:\n\n 1º Caso: 0 valor que será aumentado no resgate todo mês, caso não tenha colocado um objetivo de rendimento para aumento no resgate.\n\nExemplo:\nSeu acréscimo de resgate é de 10R$ neste mês no próximo será 20R$ e assim sucessivamente.\n\n 2º Caso: Toda vez que você atingir o objetivo de rendimento o valor será aumentado.\n\nExemplo:\nSeu acréscimo de resgate é de 10R$ quando seu rendimento que começou rendendo 100R$ atingir o objetivo de rendimento de mais 100R$, então quando seu rendimento começar a render 200R$, seu resgate será de mais 10R$."
        case .goalIncreaseRescue:
            return "É o próximo valor que você espera que seu rendimento chegue para que possa aumentar o valor de resgate do mesmo.\n\nExemplo: Seu rendimento está em 100R$ e seu resgate é de 10R$, seu objetivo de rendimento para aumento de resgate é de 100R$ e seu acréscimo no resgate é de 10R$, quando seu rendimento chegar em 200R$, seu resgate será de 20R$.\n\nOBS: Caso seu rendimento esteja alto o suficiente para que de um mês para o outro aumente 200R$, 300R$ e assim por diante, seu aumento no resgate será proporcional a ele 20R$, 30R$ e assim por diante."
        }
    }
    
    func getTitleMessageInfo() -> String {
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
            return "Valor Inicial do Resgate\n\n"
        case .increaseRescue:
            return "Acréscimo no Resgate\n\n"
        case .goalIncreaseRescue:
            return "Objetivo de Rendimento para aumento de resgate\n\n"
        }
    }
    
    func getNext(allTextFields: [INVSFloatingTextField]) -> INVSFloatingTextField? {
        return allTextFields.filter({$0.typeTextField == self.next()}).first
    }
    
    private func next() -> INVSFloatingTextFieldType? {
        return INVSFloatingTextFieldType(rawValue: rawValue + 1)
    }
}
