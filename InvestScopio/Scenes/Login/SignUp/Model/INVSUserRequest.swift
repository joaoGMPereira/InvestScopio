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
        if let passwordAES = INVSCrypto.encryptAES(withText: password) {
            self.password = passwordAES
        }
    }
}



