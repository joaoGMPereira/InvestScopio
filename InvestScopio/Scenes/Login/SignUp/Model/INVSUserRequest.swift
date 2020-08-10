//
//  INVSUserRequest.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 18/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import CryptoSwift
struct INVSUserRequest: JSONAble {
    var email: String = ""
    var password: String = ""
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

struct LoginRequest: Codable, JSONAble {
    let firebaseID: String
    let name: String
    let email: String
    let picture: String?
}
