//
//  UIFont+INVSExtension.swift
//  
//
//  Created by Joao Medeiros Pereira on 14/05/19.
//

import Foundation
import UIKit
extension UIFont {
    
    static func INVSSmallFontDefault(scale: CGFloat = 1) -> UIFont {
        return UIFont.systemFont(ofSize: 13 * scale)
    }
    
    static func INVSSmallFontDefaultBold(scale: CGFloat = 1) -> UIFont {
        return UIFont.boldSystemFont(ofSize: 13 * scale)
    }
    
    static func INVSFontDefault(scale: CGFloat = 1) -> UIFont {
        return UIFont.systemFont(ofSize: 14 * scale)
    }
    
    static func INVSFontDefaultBold(scale: CGFloat = 1) -> UIFont {
        return UIFont.boldSystemFont(ofSize: 14 * scale)
    }
    
    static func INVSFontBig(scale: CGFloat = 1) -> UIFont {
        return UIFont.systemFont(ofSize: 16 * scale)
    }
    
    static func INVSFontBigBold(scale: CGFloat = 1) -> UIFont {
        return UIFont.boldSystemFont(ofSize: 16 * scale)
    }
    
    static func INVSTitleBold(scale: CGFloat = 1) -> UIFont {
        return UIFont.boldSystemFont(ofSize: 24 * scale)
    }
    
    static func INVSTitle(scale: CGFloat = 1) -> UIFont {
        return UIFont.systemFont(ofSize: 24 * scale)
    }
    
    static func INVSSubtitleBold(scale: CGFloat = 1) -> UIFont {
        return UIFont.boldSystemFont(ofSize: 20 * scale)
    }
    
    static func INVSSubtitle(scale: CGFloat = 1) -> UIFont {
        return UIFont.systemFont(ofSize: 20 * scale)
    }
}
