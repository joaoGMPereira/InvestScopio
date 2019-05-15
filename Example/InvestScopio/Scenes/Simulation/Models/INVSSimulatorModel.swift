//
//  INVSSimulatorModel.swift
//  InvestScopio_Example
//
//  Created by Joao Medeiros Pereira on 13/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

struct INVSSimulatorModel {
    var initialValue: Double! {
        didSet {
            initialValue = initialValue.INVSrounded()
        }
    }
    var monthValue: Double? {
        didSet {
            monthValue = monthValue?.INVSrounded()
        }
    }
    var interestRate: Double! {
        didSet {
            interestRate = interestRate.INVSrounded()
        }
    }
    var totalMonths: Int! 
    var initialMonthlyRescue: Double? {
        didSet {
            initialMonthlyRescue = initialMonthlyRescue?.INVSrounded()
        }
    }
    var increaseRescue: Double? {
        didSet {
            increaseRescue = increaseRescue?.INVSrounded()
        }
    }
    var goalIncreaseRescue: Double? {
        didSet {
            goalIncreaseRescue = goalIncreaseRescue?.INVSrounded()
        }
    }
}
