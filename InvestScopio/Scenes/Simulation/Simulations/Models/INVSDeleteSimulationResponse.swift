//
//  INVSDeleteSimulationResponse.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 27/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation

struct INVSDeleteSimulationResponse: Decodable {
    let deleted: Bool
    let message: String
}
