//
//  INVSLogoutResponse.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 22/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
struct INVSLogoutResponse: Decodable {
    let error: Bool
    let message: String
}
