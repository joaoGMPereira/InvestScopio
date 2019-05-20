//
//  CAShapeLayer+INVSExtension.swift
//  InvestScopio_Example
//
//  Created by Joao Medeiros Pereira on 16/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
extension CAShapeLayer {
    static func addShadow(withRoundedCorner cornerRadius: CGFloat, andColor fillColor: UIColor, inView view:UIView) -> CAShapeLayer {
        return roundedShapeLayer(inCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], withRoundedCorner: cornerRadius, andColor: fillColor, inView: view)
    }
    
    static func addCorner(inCorners corners: UIRectCorner, withRoundedCorner cornerRadius: CGFloat, andColor fillColor: UIColor, inView view:UIView) -> CAShapeLayer {
        return roundedShapeLayer(inCorners: corners, withRoundedCorner: cornerRadius, andColor: fillColor, inView: view)
    }
    
    static func addGradientLayer(inView view: UIView, withColorsArr colors: [CGColor]) {
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = colors
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
        
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    static private func roundedShapeLayer(inCorners corners: UIRectCorner, withRoundedCorner cornerRadius: CGFloat, andColor fillColor: UIColor, inView view:UIView) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = view.frame
        shapeLayer.position = view.center
        shapeLayer.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.shadowColor = UIColor.darkGray.cgColor
        shapeLayer.shadowPath = shapeLayer.path
        shapeLayer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        shapeLayer.shadowOpacity = 0.8
        shapeLayer.shadowRadius = 1
        view.layer.insertSublayer(shapeLayer, at: 0)
        return shapeLayer
    }
}
