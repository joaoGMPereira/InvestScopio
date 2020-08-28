//
//  SimulationCreationViewType.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 27/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import ZCAnimatedLabel

enum SimulationCreationViewType: Int {
    case initialStep = 0
    case firstStep
    case secondStep
    case thirdStep
    case fourthStep
    case fifthStep
    case sixthStep
    case seventhStep
    case lastStep
    
    
    func setNextStep() -> NSMutableAttributedString {
        switch self {
        case .initialStep:
            return setInitialStep()
        case .firstStep:
            return setFirstStep()
        case .secondStep:
            return setSecondStep()
        case .thirdStep:
            return setThirdStep()
        case .fourthStep:
            return setFourthStep()
        case .fifthStep:
            return setFifthStep()
        case .sixthStep:
            return setSixthStep()
        case .seventhStep:
            return setSeventhStep()
        case .lastStep:
            return setLastStep()
        }
    }
    
    //MARK: Initial Step
    private func setInitialStep() -> NSMutableAttributedString {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.titleBold(withText: "Olá futuro investidor!\n"))
        messageMutableAttributedString.append(NSAttributedString.subtitle(withText: "Você deseja fazer uma simulação"))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "\nSimplificada "))
        messageMutableAttributedString.append(NSAttributedString.subtitle(withText: "ou "))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "Completa?"))
        return setNewAttributedText(messageMutableAttributedString: messageMutableAttributedString)
    }
    
    //MARK: TextFields Steps
    private func setFirstStep() -> NSMutableAttributedString {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.title(withText: "Quanto você teria para seu\n"))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "Primeiro Investimento?"))
        return setNewAttributedText(messageMutableAttributedString: messageMutableAttributedString)
    }

    private func setSecondStep() -> NSMutableAttributedString {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.title(withText: "Quanto você teria para colocar\n"))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "Todo Mês?"))
        return setNewAttributedText(messageMutableAttributedString: messageMutableAttributedString)
    }
    
    private func setThirdStep() -> NSMutableAttributedString {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "Qual a taxa de rendimento\ndo seu investimento?"))
        return setNewAttributedText(messageMutableAttributedString: messageMutableAttributedString)
    }

    private func setFourthStep() -> NSMutableAttributedString {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.title(withText: "Por quanto "))
        messageMutableAttributedString.append(NSAttributedString.titleBold(withText: "tempo "))
        messageMutableAttributedString.append(NSAttributedString.title(withText: "você quer \nFicar com esse investimento?"))
        return setNewAttributedText(messageMutableAttributedString: messageMutableAttributedString)
    }
    
    private func setFifthStep() -> NSMutableAttributedString {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.title(withText: "Quanto você gostaria de\n"))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "Retirar do seu primeiro rendimento?"))
        return setNewAttributedText(messageMutableAttributedString: messageMutableAttributedString)
    }
    
    private func setSixthStep() -> NSMutableAttributedString {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.title(withText: "Quanto você gostaria de\n"))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "Aumentar da sua retirada\ndo seu rendimento?"))
        return setNewAttributedText(messageMutableAttributedString: messageMutableAttributedString)
    }
    private func setSeventhStep() -> NSMutableAttributedString {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.title(withText: "Qual seria seu objetivo para\n"))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "Aumentar a retirada do seu rendimento?"))
        return setNewAttributedText(messageMutableAttributedString: messageMutableAttributedString)
    }
    
    private func setLastStep() -> NSMutableAttributedString {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.titleBold(withText: "Dados coletados!\n"))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: " você deseja simular "))
        messageMutableAttributedString.append(NSAttributedString.subtitle(withText: "ou "))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "deseja conferir seus dados?"))
        return setNewAttributedText(messageMutableAttributedString: messageMutableAttributedString)
    }
    
    //MARK: Common methods
    
    private func setNewAttributedText(messageMutableAttributedString: NSMutableAttributedString) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        style.alignment = .center
        style.lineBreakMode = .byWordWrapping
        let range: NSRange = messageMutableAttributedString.mutableString.range(of: messageMutableAttributedString.string)
        messageMutableAttributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: range)
        return messageMutableAttributedString
    }
}
