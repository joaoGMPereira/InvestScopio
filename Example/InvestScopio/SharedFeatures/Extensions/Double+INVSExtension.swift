//
//  Double+INVSExtension.swift
//  InvestScopio_Example
//
//  Created by Joao Medeiros Pereira on 14/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func INVSrounded(toPlaces places:Int = 2) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
