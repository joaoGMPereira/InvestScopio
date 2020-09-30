//
//  SimulatorModel.swift
//  InvestScopio_Example
//
//  Created by Joao Medeiros Pereira on 13/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import JewFeatures
struct SimulatorModel: JSONAble, Codable, Identifiable, Hashable {
    var initialValue: Double = 0.0 {
        didSet {
            initialValue = initialValue.INVSrounded()
        }
    }
    var monthValue: Double = 0.0 {
        didSet {
            monthValue = monthValue.INVSrounded()
        }
    }
    var interestRate: Double = 0.0 {
        didSet {
            interestRate = interestRate.INVSrounded()
        }
    }
    var totalMonths: Int = 0
    var initialMonthlyRescue: Double = 0.0 {
        didSet {
            initialMonthlyRescue = initialMonthlyRescue.INVSrounded()
        }
    }
    var increaseRescue: Double = 0.0 {
        didSet {
            increaseRescue = increaseRescue.INVSrounded()
        }
    }
    var goalIncreaseRescue: Double = 0.0 {
        didSet {
            goalIncreaseRescue = goalIncreaseRescue.INVSrounded()
        }
    }
    var isSimply: Bool? = true
    
    var id: String? {
        return _id
    }
    var _id: String?
    
    func generateDynamicContent() -> [SectionModel] {
        var sections = [SectionModel]()
        var secondSection = SectionModel()
        var thirdSection = SectionModel()
        var fourthSection = SectionModel()
        
        sections.append(SectionModel(firstKey: "Valor Inicial", firstValue: initialValue.currencyFormat(), secondKey: "Total de Meses", secondValue: "\(totalMonths)"))
        
        secondSection.firstKey = "Taxa de Juros"
        secondSection.firstValue = interestRate.currencyFormat().percentFormat()
        
        if monthValue != .zero {
            secondSection.secondKey = "Valor Mensal"
            secondSection.secondValue = monthValue.currencyFormat()
        }
        
        if initialMonthlyRescue != .zero {
            if secondSection.secondKey == nil {
                secondSection.secondKey = "Valor Inicial de Resgate"
                secondSection.secondValue = initialMonthlyRescue.currencyFormat()
            } else {
                thirdSection.firstKey = "Valor Inicial de Resgate"
                thirdSection.firstValue = initialMonthlyRescue.currencyFormat()
            }
        }
        
        if increaseRescue != .zero {
            if secondSection.secondKey == nil {
                secondSection.secondKey = "Acréscimo no Resgate"
                secondSection.secondValue = increaseRescue.currencyFormat()
            } else if thirdSection.firstKey.isEmpty {
                thirdSection.firstKey = "Acréscimo no Resgate"
                thirdSection.firstValue = increaseRescue.currencyFormat()
            } else if thirdSection.secondKey == nil {
                thirdSection.secondKey = "Acréscimo no Resgate"
                thirdSection.secondValue = increaseRescue.currencyFormat()
            } else {
                fourthSection.firstKey = "Acréscimo no Resgate"
                fourthSection.firstValue = increaseRescue.currencyFormat()
            }
        }
        if goalIncreaseRescue != .zero {
            if secondSection.secondKey == nil {
                secondSection.secondKey = "Próximo Objetivo"
                secondSection.secondValue = goalIncreaseRescue.currencyFormat()
            } else if thirdSection.firstKey.isEmpty {
                thirdSection.firstKey = "Próximo Objetivo"
                thirdSection.firstValue = goalIncreaseRescue.currencyFormat()
            } else if thirdSection.secondKey == nil {
                thirdSection.secondKey = "Próximo Objetivo"
                thirdSection.secondValue = goalIncreaseRescue.currencyFormat()
            } else if fourthSection.firstKey.isEmpty {
                fourthSection.firstKey = "Próximo Objetivo"
                fourthSection.firstValue = goalIncreaseRescue.currencyFormat()
            } else {
                fourthSection.secondKey = "Próximo Objetivo"
                fourthSection.secondValue = goalIncreaseRescue.currencyFormat()
            }
        }
        
        if !secondSection.firstKey.isEmpty {
            sections.append(secondSection)
        }
        if !thirdSection.firstKey.isEmpty {
            sections.append(thirdSection)
        }
        
        if !fourthSection.firstKey.isEmpty {
            sections.append(fourthSection)
        }
        return sections
    }
}

struct SectionModel: Identifiable {
    var id: UUID = UUID()
    var firstKey: String = String()
    var firstValue: String = String()
    var secondKey: String? = nil
    var secondValue: String? = nil
    var hasFirstSection: Bool {
        return firstKey != String()
    }
    var hasSecondSection: Bool {
        return secondKey != nil
    }
}


extension SimulatorModel {
    static let simulationsPlaceholders = [SimulatorModel.init(initialValue: 30000, monthValue: 500, interestRate: 3, totalMonths: 30, initialMonthlyRescue: 20, increaseRescue: 50, goalIncreaseRescue: 300, isSimply: false, _id: "placeholder"), SimulatorModel.init(initialValue: 30000, monthValue: 500, interestRate: 3, totalMonths: 30, initialMonthlyRescue: 20, increaseRescue: 50, goalIncreaseRescue: 300, isSimply: false, _id: "placeholder1"), SimulatorModel.init(initialValue: 30000, monthValue: 500, interestRate: 3, totalMonths: 30, initialMonthlyRescue: 20, increaseRescue: 50, goalIncreaseRescue: 300, isSimply: false, _id: "placeholder2"), SimulatorModel.init(initialValue: 30000, monthValue: 500, interestRate: 3, totalMonths: 30, initialMonthlyRescue: 20, increaseRescue: 50, goalIncreaseRescue: 300, isSimply: false, _id: "placeholder3")]
    
}
