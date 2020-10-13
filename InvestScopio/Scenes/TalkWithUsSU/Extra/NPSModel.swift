//
//  INSEvaluateModel.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 30/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import JewFeatures

struct NPSModel: Codable, JSONAble {
    var rate: Int
    var versionApp: String
    var versionSO: String
    var _id: String?
}

struct NPSResponse: Codable {
    let message: String
    let evaluated: Bool
}
