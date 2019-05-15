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
    
    func getNext(allTextFields: [INVSFloatingTextField]) -> INVSFloatingTextField? {
        return allTextFields.filter({$0.typeTextField == self.next()}).first
    }
    
    private func next() -> INVSFloatingTextFieldType? {
        return INVSFloatingTextFieldType(rawValue: rawValue + 1)
    }
}
