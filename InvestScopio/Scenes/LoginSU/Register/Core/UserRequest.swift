//
//  INVSUserRequest.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 18/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import CryptoSwift

struct UserRequest: Codable, JSONAble {
    let firebaseID: String
    let name: String
    let email: String
    let picture: String?
    
    public init(email: String? = "User Without Email", uid: String, fullName: String? = "User Without Email", photoURL: URL? = nil) {
        self.email = email ?? "User Without Email"
        self.firebaseID = uid
        self.name = fullName ?? "User Without Email"
        self.picture = photoURL?.absoluteString
    }
}
