//
//  FirebaseErrorHandler.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 14/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import Firebase

enum FireBaseErrorHandler: Int {
    case codeUserDisabled = 17005
    case codeEmailAlreadyInUse = 17007
    case codeInvalidEmail = 17008
    case codeWrongPassword = 17009
    case codeUserNotFound = 17011
    case codeInvalidUserToken = 17017
    case codeWeakPassword = 17026
    case unknown = 999
    
    func getFirebaseMessage() -> String {
        switch self {
        case .codeUserDisabled:
            return "Email desativado!"
        case .codeEmailAlreadyInUse:
            return "Email já cadastrado!"
        case .codeInvalidEmail:
            return "Email inválido!"
        case .codeWrongPassword:
            return "Senha incorreta!"
        case .codeUserNotFound:
            return "Email não cadastrado!"
        case .codeInvalidUserToken:
            return "Tente logar novamente em breve!"
        case .codeWeakPassword:
            return "Sua senha deve ter pelo menos 6 caracteres!"
        default:
            return "Desculpe, tivemos algum problema, tente novamente mais tarde!"
        }
        
    }
}
