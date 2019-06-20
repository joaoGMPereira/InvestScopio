//
//  INVSResendPasswordViewController.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 13/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import UIKit

protocol INVSResendPasswordViewControllerProtocol: class {
    func displayOkAction(withTextField textField: INVSFloatingTextField, andShouldResign shouldResign: Bool)
    func displayCancelAction()
    func displayResendPasswordSuccess(withEmail email:String, title:String, message:String, shouldHideAutomatically:Bool, popupType:INVSPopupMessageType)
    func displayResendPasswordError(titleError:String, messageError:String, shouldHideAutomatically:Bool, popupType:INVSPopupMessageType)
    
}

class INVSResendPasswordViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: INVSFloatingTextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var resendPasswordButton: INVSLoadingButton!
    @IBOutlet weak var contentViewCenterYConstraint: NSLayoutConstraint!
    var popupMessage: INVSPopupMessage?
    var interactor: INVSResendPasswordInteractorProtocol?
    var router: INVSRoutingLogic?
    var firstMinYContentView: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupUI()
        let _ = CAShapeLayer.addCorner(withShapeLayer: nil, withCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], withRoundedCorner: 8, andColor: .white, inView: contentView)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        let interactor = INVSResendPasswordInteractor()
        let presenter = INVSResendPasswordPresenter()
        let router = INVSRouter()
        interactor.allTextFields = [emailTextField]
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
        
        resendPasswordButton.setupBorded(title: "Recuperar")
        resendPasswordButton.buttonAction = { (button) -> () in
            self.resendPasswordButton.showLoading()
            self.interactor?.resendPassword()
        }
        cancelButton.setTitleColor(.INVSRed(), for: .normal)
        cancelButton.layer.borderColor = UIColor.INVSRed().cgColor
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.cornerRadius = 20
        popupMessage = INVSPopupMessage(parentViewController: self)
        popupMessage?.delegate = self
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension INVSResendPasswordViewController: INVSPopupMessageDelegate {
    func didFinishDismissPopupMessage(withPopupMessage popupMessage: INVSPopupMessage) {
        if popupMessage.popupType == .alert {
            view.endEditing(true)
            dismiss(animated: true, completion: nil)
        }
    }
}

extension INVSResendPasswordViewController: INVSFloatingTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: INVSFloatingTextField) {
    }
    func toolbarAction(_ textField: INVSFloatingTextField, typeOfAction type: INVSKeyboardToolbarButton) {
        interactor?.checkToolbarAction(withTextField: textField, typeOfAction: type)
    }
    
    func infoButtonAction(_ textField: INVSFloatingTextField) {
        view.endEditing(true)
    }
    
}

extension INVSResendPasswordViewController: INVSResendPasswordViewControllerProtocol {
    func displayResendPasswordSuccess(withEmail email:String, title:String, message:String, shouldHideAutomatically:Bool, popupType:INVSPopupMessageType) {
        resendPasswordButton.hideLoading()
        popupMessage?.show(withTextMessage: message, title: title, popupType: popupType, shouldHideAutomatically: shouldHideAutomatically)
    }
    
    func displayResendPasswordError(titleError:String, messageError:String, shouldHideAutomatically:Bool, popupType:INVSPopupMessageType) {
        resendPasswordButton.hideLoading()
        popupMessage?.show(withTextMessage: messageError, title: titleError, popupType: popupType, shouldHideAutomatically: shouldHideAutomatically)
    }
    
    func displayOkAction(withTextField textField: INVSFloatingTextField, andShouldResign shouldResign: Bool) {
        textField.floatingTextField.becomeFirstResponder()
        if shouldResign {
            interactor?.resendPassword()
            view.endEditing(shouldResign)
        }
    }
    
    func displayCancelAction() {
        view.endEditing(true)
    }
    
    
}
