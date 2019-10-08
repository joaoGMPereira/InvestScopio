//
//  Jsonable+INVSExtension.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 19/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation

protocol JSONAble {}

extension JSONAble {
    func toDict() -> [String:Any] {
        var dict = [String:Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label {
                let object = checkTypeOfObject(object: child.value)
                dict[key] = object
            }
        }
        return dict
    }
    
    func checkTypeOfObject(object: Any) -> Any {
        if let interestRateType = object as? INVSInterestRateType {
            return interestRateType.rawValue
        } else {
            return object
        }
    }
}
