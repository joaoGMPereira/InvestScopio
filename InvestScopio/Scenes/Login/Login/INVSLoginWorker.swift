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
import Alamofire

typealias PopMessageLoginInfo = (title: String, message: String)
typealias SuccessLoginHandler = (INVSUserModel) -> ()
typealias ErrorLoginHandler = (_ titleError:String,_ messageError:String, _ shouldHideAutomatically:Bool, _ popupType:INVSPopupMessageType) ->()

typealias LogoutHandler = () ->()


protocol INVSLoginWorkerProtocol {
    func login(withTextFields textFields: [INVSFloatingTextField], successCompletionHandler: @escaping(SuccessLoginHandler), errorCompletionHandler:@escaping(ErrorLoginHandler))
    func loggedUser(withEmail email: String, security: String, successCompletionHandler: @escaping(SuccessLoginHandler), errorCompletionHandler:@escaping(ErrorLoginHandler))
    func logout(logoutHandler: @escaping(LogoutHandler))
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
                    if let error = error {
                        if let firebaseErrorHandler = FireBaseErrorHandler.init(rawValue: error._code)?.getFirebaseError() {
                            errorCompletionHandler(firebaseErrorHandler.titleError, firebaseErrorHandler.messageError, firebaseErrorHandler.shouldHideAutomatically, firebaseErrorHandler.popupType)
                            return
                        }
                    }
                    errorCompletionHandler(INVSFloatingTextFieldType.defaultErrorTitle(), INVSFloatingTextFieldType.defaultErrorMessage(), true, .error)
                    return
                }
                let userFirebaseModel = INVSUserModel.init(email: user.email ?? "", uid: user.uid)
                self.signInInvestScopioAPI(user: userFirebaseModel, successLoginHandler: { (userAPI) in
                    successCompletionHandler(userAPI)
                }, errorCompletionHandler: { (title, message, shouldHideAutomatically, popupType) in
                    errorCompletionHandler(title, message, shouldHideAutomatically, popupType)
                })
                return
            }
        }
    }
    
    func loggedUser(withEmail email: String, security: String, successCompletionHandler: @escaping (SuccessLoginHandler), errorCompletionHandler: @escaping (ErrorLoginHandler)) {
        let userRememberLoggedModel = INVSUserModel(email: email, uid: security)
        signInInvestScopioAPI(user: userRememberLoggedModel, successLoginHandler: { (userAPI) in
            successCompletionHandler(userAPI)
        }, errorCompletionHandler: { (title, message, shouldHideAutomatically, popupType) in
            errorCompletionHandler(title, message, shouldHideAutomatically, popupType)
        })
    }
    
    func signInInvestScopioAPI(user: INVSUserModel, successLoginHandler: @escaping(SuccessLoginHandler), errorCompletionHandler:@escaping(ErrorLoginHandler)) {
        let headers = ["Content-Type": "application/json"]
        
        let userRequest = INVSUserRequest(email: user.email, password: user.uid)
        
        INVSConector.connector.request(withURL: INVSConector.getURL(withRoute: "/account/sign-in"), method: .post, parameters: userRequest, responseClass: INVSAccessModel.self, headers: headers, shouldRetry: true, successCompletion: { (decodable) in
            
            var userResponse = user
            if let access = decodable as? INVSAccessModel {
                userResponse.access = access
            }
            successLoginHandler(userResponse)
        }) { (error) in
            errorCompletionHandler(INVSFloatingTextFieldType.defaultErrorTitle(), error.reason, true, .error)
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
    
    
    func logout(logoutHandler: @escaping(LogoutHandler)) {
        guard let headers = ["Content-Type": "application/json", "Authorization": INVSSession.session.user?.access?.accessToken] as? HTTPHeaders else {
            logoutHandler()
            return
        }
        INVSConector.connector.request(withURL: INVSConector.getURL(withRoute: "/account/logout"), method: .post, responseClass: INVSLogoutResponse.self, headers: headers, successCompletion: { (decodable) in
            if let logout = decodable as? INVSLogoutResponse {
                print(logout)
            }
            logoutHandler()
        }) { (error) in
            logoutHandler()
        }
    }
}
