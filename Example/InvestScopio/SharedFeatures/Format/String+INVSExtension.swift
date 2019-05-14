//
//  INVSTextFieldFormat.swift
//  InvestEx_Example
//
//  Created by Joao Medeiros Pereira on 12/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

extension String {
    // formatting text for currency textField
    public func percentFormat(backSpace: Bool = false) -> String {
        var number: NSNumber!
        let formatter = NumberFormatter.currencyDefault()
        formatter.numberStyle = .currencyAccounting
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithoutPrefix = self
        
        // remove from String: "$", ".", ","
        amountWithoutPrefix = stringOfNumbersRegex(with: 5)
        if backSpace {
            amountWithoutPrefix = String(amountWithoutPrefix.prefix(amountWithoutPrefix.count - 1))
        }
        let double = (amountWithoutPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        let stringWithSymbol = formatter.string(from: number)!
        return stringWithSymbol.addPercentSymbol()
    }
    
    private func addPercentSymbol() -> String {
        let stringWithSymbol = "\(self.replacingOccurrences(of: "R$", with: ""))%"
        return stringWithSymbol
    }
    
    public func currencyFormat() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter.currencyDefault()

        var amountWithoutPrefix = self
        
        // remove from String: "$", ".", ","
        amountWithoutPrefix = stringOfNumbersRegex(with: 15)
        
        let double = (amountWithoutPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
    
    public func monthFormat() -> String {
        
        var amountWithoutPrefix = self
        
        // remove from String: "$", ".", ","
        amountWithoutPrefix = stringOfNumbersRegex(with: 3)
        
        return amountWithoutPrefix
    }
    
    public func convertFormattedToInt() -> Int {
        let intValue = (self.stringOfNumbersRegex() as NSString).intValue
        let number = NSNumber(value: (intValue))
        return number.intValue
    }
    
    public func convertFormattedToDouble() -> Double {
        let double = (self.stringOfNumbersRegex() as NSString).doubleValue
        let number = NSNumber(value: (double / 100))
        return number.doubleValue
    }
    
    private func stringOfNumbersRegex(with size:Int? = nil) -> String {
        var amountWithPrefix = self
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = String(regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "").prefix(size ?? self.count))
        return amountWithPrefix
    }
}


