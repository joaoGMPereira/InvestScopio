//
//  LoginWorker.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 12/06/19.
//  Copyright (c) 2019 Joao Medeiros Pereira. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Firebase
typealias PopMessageLoginInfo = (title: String, message: String)
typealias SuccessLoginHandler = (User) -> ()
typealias ErrorLoginHandler = (_ titleError:String,_ messageError:String, _ shouldHideAutomatically:Bool, _ popupType:INVSPopupMessageType) ->()

protocol INVSLoginWorkerProtocol {
    func login(withTextFields textFields: [INVSFloatingTextField], successCompletionHandler: @escaping(SuccessLoginHandler), errorCompletionHandler:@escaping(ErrorLoginHandler))
}

class INVSLoginWorker: NSObject,INVSLoginWorkerProtocol {
    func login(withTextFields textFields: [INVSFloatingTextField], successCompletionHandler: @escaping(SuccessLoginHandler), errorCompletionHandler:@escaping(ErrorLoginHandler)) {
        if let textFieldsError = check(withTextFields: textFields) {
            errorCompletionHandler(textFieldsError.title, textFieldsError.message, true, .error)
            return
        }
        if let email = textFields.filter({$0.typeTextField == .email}).first?.floatingTextField.text?.lowercased(), let password = textFields.filter({$0.typeTextField == .password}).first?.floatingTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                guard let user = result?.user else {
                    errorCompletionHandler(INVSFloatingTextFieldType.defaultTitle(), INVSFloatingTextFieldType.defaultMessage(), true, .error)
                    return
                }
                successCompletionHandler(user)
                return
            }
        }
    }
    private func check(withTextFields textFields:[INVSFloatingTextField]) -> PopMessageLoginInfo? {
        if let emailTextField = textFields.filter({$0.typeTextField == .email}).first {
            if emailTextField.floatingTextField.text?.isValidEmail() == false {
                if emailTextField.required {
                    emailTextField.hasError = true
                    emailTextField.floatingTextField.becomeFirstResponder()
                }
                return PopMessageLoginInfo(title: emailTextField.typeTextField?.getTitleMessageInfo() ?? "", message: emailTextField.typeTextField?.getMessageInfo() ?? "")
            }
            emailTextField.hasError = false
        }
        return nil
    }
}
