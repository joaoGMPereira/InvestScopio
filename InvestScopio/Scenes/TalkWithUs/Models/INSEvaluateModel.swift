//
//  INSEvaluateModel.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 30/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation

struct INVSEvaluateModel: JSONAble {
    var rate: Int
    var version: Double
    var versionSO: String
}

struct INVSEvaluateResponse: Decodable {
    let message: String
    let evaluated: Bool
}
