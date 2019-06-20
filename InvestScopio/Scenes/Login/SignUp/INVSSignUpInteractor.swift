//
//  LoginInteractor.swift
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

protocol INVSSignUpInteractorProtocol {
    func checkToolbarAction(withTextField textField: INVSFloatingTextField, typeOfAction type: INVSKeyboardToolbarButton)
    func signUp()
    var allTextFields: [INVSFloatingTextField] { get }
    var email: String {get}
}

class INVSSignUpInteractor: INVSSignUpInteractorProtocol {
    
    var presenter: INVSSignUpPresenterProtocol?
    var worker: INVSSignUpWorkerProtocol = INVSSignUpWorker()
    var allTextFields = [INVSFloatingTextField]()
    var email: String = ""
    
  // MARK: Do something
  
    func checkToolbarAction(withTextField textField: INVSFloatingTextField, typeOfAction type: INVSKeyboardToolbarButton) {
        presenter?.presentToolbarAction(withPreviousTextField: textField, allTextFields: allTextFields, typeOfAction: type)
    }
    
    func signUp() {
        worker.signUp(withTextFields: allTextFields, successCompletionHandler: { (user, title, message, shouldHideAutomatically, popupType) in
            self.email = user.email
            self.presenter?.presentSuccessSignUp(withEmail: user.email, title: title, message: message, shouldHideAutomatically: shouldHideAutomatically, popupType: popupType)
        }, errorCompletionHandler: { (title, message, shouldHideAutomatically, popupType) in
            self.presenter?.presentErrorSignUp(titleError: title, messageError: message, shouldHideAutomatically: shouldHideAutomatically, popupType: popupType)
        })
    }
}