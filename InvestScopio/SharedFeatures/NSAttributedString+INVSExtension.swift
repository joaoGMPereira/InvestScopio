//
//  NSAttributedString+INVSExtension.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 02/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    
    static func title(withText text: String, scale: CGFloat = 1) -> NSAttributedString {
        return set(withText: text, andFont: UIFont.INVSTitle())
    }
    
    static func titleBold(withText text: String, scale: CGFloat = 1) -> NSAttributedString {
        return set(withText: text, andFont: UIFont.INVSTitleBold(scale: scale))
    }
    
    static func subtitle(withText text: String, scale: CGFloat = 1) -> NSAttributedString {
        return set(withText: text, andFont: UIFont.INVSSubtitle(scale: scale))
    }
    
    static func subtitleBold(withText text: String, scale: CGFloat = 1) -> NSAttributedString {
        return set(withText: text, andFont: UIFont.INVSSubtitleBold(scale: scale))
    }
    
    static func set(withText text: String, andFont font:UIFont) -> NSAttributedString {
        return NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor: UIColor.label])
    }
    
    
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}
