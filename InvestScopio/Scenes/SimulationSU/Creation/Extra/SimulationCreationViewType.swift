//
//  SimulationCreationViewType.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 27/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import SwiftUI
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
    
    func setNextStepPlaceHolder() -> String {
        switch self {
        case .initialStep:
            return String()
        case .firstStep:
            return "Valor Inicial"
        case .secondStep:
            return "Investimento Mensal"
        case .thirdStep:
            return "Taxa de Juros"
        case .fourthStep:
            return "Total de Meses"
        case .fifthStep:
            return "Valor Inicial para resgatar do seu rendimento"
        case .sixthStep:
            return "Acréscimo no resgate"
        case .seventhStep:
            return "Objetivo de rendimento para aumento de resgate"
        case .lastStep:
            return String()
        }
    }
    
    
    func setNextStep(size: ContentSizeCategory) -> NSMutableAttributedString {
        let scale = calculateScale(size: size)
        switch self {
        case .initialStep:
            return setInitialStep(scale: scale)
        case .firstStep:
            return setFirstStep(scale: scale)
        case .secondStep:
            return setSecondStep(scale: scale)
        case .thirdStep:
            return setThirdStep(scale: scale)
        case .fourthStep:
            return setFourthStep(scale: scale)
        case .fifthStep:
            return setFifthStep(scale: scale)
        case .sixthStep:
            return setSixthStep(scale: scale)
        case .seventhStep:
            return setSeventhStep(scale: scale)
        case .lastStep:
            return setLastStep(scale: scale)
        }
    }
    
    func calculateScale(size: ContentSizeCategory) -> CGFloat {
        switch size {
        case .extraSmall:
            return 0.9
        case .small:
            return 0.95
        case .medium:
            return 1
        case .large:
            return 1.05
        case .extraLarge:
            return 1.1
        case .extraExtraLarge:
            return 1.15
        case .extraExtraExtraLarge:
            return 1.2
        case .accessibilityMedium:
            return 1.25
        case .accessibilityLarge:
            return 1.3
        case .accessibilityExtraLarge:
            return 1.35
        case .accessibilityExtraExtraLarge:
            return 1.4
        case .accessibilityExtraExtraExtraLarge:
            return 1.45
        @unknown default:
            return 1.0
        }
    }
    
    //MARK: Initial Step
    private func setInitialStep(scale: CGFloat = 1) -> NSMutableAttributedString {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.titleBold(withText: "Olá futuro investidor!\n", scale: scale))
        messageMutableAttributedString.append(NSAttributedString.subtitle(withText: "Você deseja fazer uma simulação", scale: scale))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "\nSimplificada ", scale: scale))
        messageMutableAttributedString.append(NSAttributedString.subtitle(withText: "ou ", scale: scale))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "Completa?", scale: scale))
        return setNewAttributedText(messageMutableAttributedString: messageMutableAttributedString)
    }
    
    //MARK: TextFields Steps
    private func setFirstStep(scale: CGFloat = 1) -> NSMutableAttributedString {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.title(withText: "Quanto você teria para seu\n", scale: scale))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "Primeiro Investimento?", scale: scale))
        return setNewAttributedText(messageMutableAttributedString: messageMutableAttributedString)
    }

    private func setSecondStep(scale: CGFloat = 1) -> NSMutableAttributedString {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.title(withText: "Quanto você teria para colocar\n", scale: scale))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "Todo Mês?", scale: scale))
        return setNewAttributedText(messageMutableAttributedString: messageMutableAttributedString)
    }
    
    private func setThirdStep(scale: CGFloat = 1) -> NSMutableAttributedString {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "Qual a taxa de rendimento\ndo seu investimento?", scale: scale))
        return setNewAttributedText(messageMutableAttributedString: messageMutableAttributedString)
    }

    private func setFourthStep(scale: CGFloat = 1) -> NSMutableAttributedString {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.title(withText: "Por quanto ", scale: scale))
        messageMutableAttributedString.append(NSAttributedString.titleBold(withText: "tempo ", scale: scale))
        messageMutableAttributedString.append(NSAttributedString.title(withText: "você quer \nFicar com esse investimento?", scale: scale))
        return setNewAttributedText(messageMutableAttributedString: messageMutableAttributedString)
    }
    
    private func setFifthStep(scale: CGFloat = 1) -> NSMutableAttributedString {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.title(withText: "Quanto você gostaria de\n", scale: scale))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "Retirar do seu primeiro rendimento?", scale: scale))
        return setNewAttributedText(messageMutableAttributedString: messageMutableAttributedString)
    }
    
    private func setSixthStep(scale: CGFloat = 1) -> NSMutableAttributedString {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.title(withText: "Quanto você gostaria de\n", scale: scale))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "Aumentar da sua retirada\ndo seu rendimento?", scale: scale))
        return setNewAttributedText(messageMutableAttributedString: messageMutableAttributedString)
    }
    private func setSeventhStep(scale: CGFloat = 1) -> NSMutableAttributedString {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.title(withText: "Qual seria seu objetivo para\n", scale: scale))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "Aumentar a retirada do seu rendimento?", scale: scale))
        return setNewAttributedText(messageMutableAttributedString: messageMutableAttributedString)
    }
    
    private func setLastStep(scale: CGFloat = 1) -> NSMutableAttributedString {
        let messageMutableAttributedString = NSMutableAttributedString()
        messageMutableAttributedString.append(NSAttributedString.titleBold(withText: "Dados coletados!\n", scale: scale))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: " você deseja simular ", scale: scale))
        messageMutableAttributedString.append(NSAttributedString.subtitle(withText: "ou ", scale: scale))
        messageMutableAttributedString.append(NSAttributedString.subtitleBold(withText: "deseja conferir seus dados?", scale: scale))
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
