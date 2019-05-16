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
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: cornerRadius).cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.shadowColor = UIColor.darkGray.cgColor
        shapeLayer.shadowPath = shapeLayer.path
        shapeLayer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        shapeLayer.shadowOpacity = 0.8
        shapeLayer.shadowRadius = 1
        
        view.layer.insertSublayer(shapeLayer, at: 0)
        //layer.insertSublayer(shadowLayer, below: nil) // also works
        return shapeLayer
    }
    
    static func addCorner(inCorners corners: UIRectCorner, withRoundedCorner cornerRadius: CGFloat, andColor fillColor: UIColor, inView view:UIView) -> CAShapeLayer {
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
//        let rectShape = CAShapeLayer()
//        rectShape.bounds = self.myView.frame
//        rectShape.position = self.myView.center
//        rectShape.path = UIBezierPath(roundedRect: self.myView.bounds, byRoundingCorners: [.bottomLeft , .bottomRight , .topLeft], cornerRadii: CGSize(width: 20, height: 20)).cgPath
//
//        self.myView.layer.backgroundColor = UIColor.green.cgColor
//        //Here I'm masking the textView's layer with rectShape layer
//        self.myView.layer.mask = rectShape
        return shapeLayer
    }
}
