//
//  FirebaseErrorHandler.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 14/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import Firebase
typealias FirebaseError = (titleError:String, messageError:String, shouldHideAutomatically:Bool, popupType:INVSPopupMessageType)
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
            return "Atenção!\nEmail desativado!"
        case .codeEmailAlreadyInUse:
            return "Atenção!\nEmail já cadastrado!"
        case .codeInvalidEmail:
            return "Atenção!\nEmail inválido!"
        case .codeWrongPassword:
            return "Atenção!\nSenha incorreta!"
        case .codeUserNotFound:
            return "Atenção!\nEmail não cadastrado!"
        case .codeInvalidUserToken:
            return "Atenção!\nTente logar novamente em breve!"
        case .codeWeakPassword:
            return "Atenção!\nSua senha deve ter pelo menos 6 caracteres!"
        default:
            return "Atenção!\nDesculpe, tivemos algum problema, tente novamente mais tarde!"
        }
        
    }
}
