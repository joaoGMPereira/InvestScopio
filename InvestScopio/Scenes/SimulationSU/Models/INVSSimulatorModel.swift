//
//  INVSSimulatorModel.swift
//  InvestScopio_Example
//
//  Created by Joao Medeiros Pereira on 13/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

struct INVSSimulatorModel: JSONAble, Codable, Identifiable, Hashable {
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
}


extension INVSSimulatorModel {
    static let simulationsPlaceholders = [INVSSimulatorModel.init(initialValue: 30000, monthValue: 500, interestRate: 3, totalMonths: 30, initialMonthlyRescue: 20, increaseRescue: 50, goalIncreaseRescue: 300, isSimply: false, _id: "placeholder"), INVSSimulatorModel.init(initialValue: 30000, monthValue: 500, interestRate: 3, totalMonths: 30, initialMonthlyRescue: 20, increaseRescue: 50, goalIncreaseRescue: 300, isSimply: false, _id: "placeholder1"), INVSSimulatorModel.init(initialValue: 30000, monthValue: 500, interestRate: 3, totalMonths: 30, initialMonthlyRescue: 20, increaseRescue: 50, goalIncreaseRescue: 300, isSimply: false, _id: "placeholder2"), INVSSimulatorModel.init(initialValue: 30000, monthValue: 500, interestRate: 3, totalMonths: 30, initialMonthlyRescue: 20, increaseRescue: 50, goalIncreaseRescue: 300, isSimply: false, _id: "placeholder3")]
    
}
