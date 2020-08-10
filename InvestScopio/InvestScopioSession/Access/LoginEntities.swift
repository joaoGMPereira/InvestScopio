//
//  PublicKey.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 01/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation

struct HTTPPublicKey: Codable {
    let publicKey: String
}

struct HTTPAccessToken: Codable {
    let accessToken: String
}

struct SessionTokenModel: Codable {
    let sessionToken: String
}
