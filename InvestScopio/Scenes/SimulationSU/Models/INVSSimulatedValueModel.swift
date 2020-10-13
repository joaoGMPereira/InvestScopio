//
//  INVSSimulatedValueModel.swift
//  InvestScopio_Example
//
//  Created by Joao Medeiros Pereira on 14/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

struct INVSSimulatedValueModel: Codable, Identifiable {
    var id: String
    
    var month: Int?
    var monthValue: Double? {
        didSet {
            monthValue = monthValue?.INVSrounded()
        }
    }
    var profitability: Double? {
        didSet {
            profitability = profitability?.INVSrounded()
        }
    }
    var rescue: Double? {
        didSet {
            rescue = rescue?.INVSrounded()
        }
    }
    var total: Double? {
        didSet {
            total = total?.INVSrounded()
        }
    }
    
    var totalRescue: Double? {
        didSet {
            totalRescue = totalRescue?.INVSrounded()
        }
    }
}
