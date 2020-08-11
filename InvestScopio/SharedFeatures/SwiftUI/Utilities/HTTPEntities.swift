//
//  HTTPEntities.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 10/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation


struct HTTPResponse<Value>: Codable where Value: Codable {
    let data: Value
    let message: String?
    let response: BaseResponse
    
    struct BaseResponse: Codable {
        let code: Int
        let status: String
    }
}

struct HTTPRequest: Codable, JSONAble {
    let data: String
}
