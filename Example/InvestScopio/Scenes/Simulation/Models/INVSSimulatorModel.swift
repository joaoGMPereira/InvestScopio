//
//  INVSSimulatorModel.swift
//  InvestScopio_Example
//
//  Created by Joao Medeiros Pereira on 13/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

struct INVSSimulatorModel {
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
}
