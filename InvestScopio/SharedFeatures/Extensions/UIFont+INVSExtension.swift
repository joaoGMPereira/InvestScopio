//
//  UIFont+INVSExtension.swift
//  
//
//  Created by Joao Medeiros Pereira on 14/05/19.
//

import Foundation
import UIKit
extension UIFont {
    
    static func INVSFontDefault() -> UIFont {
        return UIFont.systemFont(ofSize: 14)
    }
    
    static func INVSFontBig() -> UIFont {
        return UIFont.systemFont(ofSize: 15)
    }
    
    static func INVSFontBigBold() -> UIFont {
        return UIFont.boldSystemFont(ofSize: 16)
    }
}
