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
    
    static func title(withText text: String, textColor: UIColor = .black) -> NSAttributedString {
        return set(withText: text, andFont: UIFont.INVSTitle(), textColor: textColor)
    }
    
    static func titleBold(withText text: String, textColor: UIColor = .black) -> NSAttributedString {
        return set(withText: text, andFont: UIFont.INVSTitleBold(), textColor: textColor)
    }
    
    static func subtitle(withText text: String, textColor: UIColor = .black) -> NSAttributedString {
        return set(withText: text, andFont: UIFont.INVSSubtitle(), textColor: textColor)
    }
    
    static func subtitleBold(withText text: String, textColor: UIColor = .black) -> NSAttributedString {
        return set(withText: text, andFont: UIFont.INVSSubtitleBold(), textColor: textColor)
    }
    
    static func set(withText text: String, andFont font:UIFont, textColor: UIColor = .black) -> NSAttributedString {
        return NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor : textColor])
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
    
    func getNewWidth(with widthConstraint: NSLayoutConstraint) -> CGFloat  {
            
            let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: widthConstraint.constant, height: CGFloat(MAXFLOAT)))
            let frameSetterRef : CTFramesetter = CTFramesetterCreateWithAttributedString(self as CFAttributedString)
            let frameRef: CTFrame = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0, 0), path.cgPath, nil)
            
            let linesNS: NSArray  = CTFrameGetLines(frameRef)
            
            guard let lines = linesNS as? [CTLine] else {return 0}
            var width = 0.0
            lines.forEach({
                let nextWidth = Double(CTLineGetBoundsWithOptions($0, CTLineBoundsOptions.useGlyphPathBounds).width)
                if nextWidth > width {
                    width = nextWidth
                }
            })
            
            return  CGFloat(width + 30)
            
        }
}
