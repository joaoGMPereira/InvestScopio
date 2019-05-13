//
//  ISPaletteColors.swift
//  InvestEx_Example
//
//  Created by Joao Medeiros Pereira on 11/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    static func INVSPallete(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    static func INVSDefault() -> UIColor {
        return UIColor.INVSPallete(red: 83, green: 77, blue: 185)
    }
}
