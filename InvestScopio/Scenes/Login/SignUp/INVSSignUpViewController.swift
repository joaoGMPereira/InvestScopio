//
//  INVSSignUpViewController.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 13/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import UIKit
import Firebase
import Lottie

protocol INVSSignUpViewControllerProtocol: class {
    func displayOkAction(withTextField textField: INVSFloatingTextField, andShouldResign shouldResign: Bool)
    func displayCancelAction()
    func displaySignUpSuccess(withEmail email:String, title:String, message:String, shouldHideAutomatically:Bool, popupType:INVSPopupMessageType)
    func displaySignUpError(titleError:String, messageError:String, shouldHideAutomatically:Bool, popupType:INVSPopupMessageType)
    
}

protocol INVSSignUpViewControllerDelegate {
    func didSignUp(withEmail email: String)
}

class INVSSignUpViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: INVSFloatingTextField!
    @IBOutlet weak var passwordTextField: INVSFloatingTextField!
    @IBOutlet weak var confirmPasswordTextField: INVSFloatingTextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var signUpButton: INVSLoadingButton!
    @IBOutlet weak var contentViewCenterYConstraint: NSLayoutConstraint!
    var popupMessage: INVSPopupMessage?
    var interactor: INVSSignUpInteractorProtocol?
    var router: INVSRoutingLogic?
    var firstMinYContentView: CGFloat = 0
    var delegate: INVSSignUpViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupUI()
        let _ = CAShapeLayer.addCorner(withShapeLayer: nil, withCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], withRoundedCorner: 8, andColor: .white, inView: contentView)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        signUpButton.setupBorded(title: "Cadastrar")
        signUpButton.buttonAction = { (button) -> () in
            self.signUpButton.showLoading()
            self.interactor?.signUp()
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        self.contentViewCenterYConstraint.constant = -120
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        contentViewCenterYConstraint.constant = 0
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = INVSSignUpInteractor()
        let presenter = INVSSignUpPresenter()
        let router = INVSRouter()
        interactor.allTextFields = [emailTextField, passwordTextField, confirmPasswordTextField]
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    func setupUI() {
        firstMinYContentView = contentView.frame.minY
        titleLabel.textColor = .INVSBlack()
        titleLabel.font = .INVSFontBigBold()
        INVSFloatingTextFieldType.email.setupTextField(withTextField: emailTextField,keyboardType: .emailAddress, andDelegate: self, valueTypeTextField: .none, isRequired: true)
        emailTextField.floatingTextField.autocapitalizationType = .none
        INVSFloatingTextFieldType.password.setupTextField(withTextField: passwordTextField,keyboardType: .default, andDelegate: self, valueTypeTextField: .none, isRequired: true)
        INVSFloatingTextFieldType.confirmPassword.setupTextField(withTextField: confirmPasswordTextField,keyboardType: .default, andDelegate: self, valueTypeTextField: .none, isRequired: true)
        passwordTextField.floatingTextField.isSecureTextEntry = true
        confirmPasswordTextField.floatingTextField.isSecureTextEntry = true
        cancelButton.setTitleColor(.INVSRed(), for: .normal)
        cancelButton.layer.borderColor = UIColor.INVSRed().cgColor
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.cornerRadius = 25
        popupMessage = INVSPopupMessage(parentViewController: self)
        popupMessage?.delegate = self
    }

    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension INVSSignUpViewController: INVSPopupMessageDelegate {
    func didFinishDismissPopupMessage(withPopupMessage popupMessage: INVSPopupMessage) {
        if popupMessage.popupType == .alert {
            self.delegate?.didSignUp(withEmail: interactor?.email ?? "")
            view.endEditing(true)
            dismiss(animated: true, completion: nil)
        }
    }
}

extension INVSSignUpViewController: INVSFloatingTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: INVSFloatingTextField) {
        //        self.popupMessage?.hide()
    }
    func toolbarAction(_ textField: INVSFloatingTextField, typeOfAction type: INVSKeyboardToolbarButton) {
        interactor?.checkToolbarAction(withTextField: textField, typeOfAction: type)
    }
    
    func infoButtonAction(_ textField: INVSFloatingTextField) {
        view.endEditing(true)
        //        interactor?.showInfo(withSender: textField)
    }
    
}

extension INVSSignUpViewController: INVSSignUpViewControllerProtocol {
    func displaySignUpSuccess(withEmail email:String, title:String, message:String, shouldHideAutomatically:Bool, popupType:INVSPopupMessageType) {
        signUpButton.hideLoading()
        popupMessage?.show(withTextMessage: message, title: title, popupType: popupType, shouldHideAutomatically: shouldHideAutomatically)
    }
    
    func displaySignUpError(titleError:String, messageError:String, shouldHideAutomatically:Bool, popupType:INVSPopupMessageType) {
        signUpButton.hideLoading()
        popupMessage?.show(withTextMessage: messageError, title: titleError, popupType: popupType, shouldHideAutomatically: shouldHideAutomatically)
    }
    
    func displayOkAction(withTextField textField: INVSFloatingTextField, andShouldResign shouldResign: Bool) {
        textField.floatingTextField.becomeFirstResponder()
        if shouldResign {
            interactor?.signUp()
            view.endEditing(shouldResign)
        }
    }
    
    func displayCancelAction() {
        view.endEditing(true)
    }
    
    
}
