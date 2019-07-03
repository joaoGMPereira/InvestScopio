//
//  ViewController.swift
//  InvestEx
//
//  Created by Joao Medeiros Pereira on 05/10/2019.
//  Copyright (c) 2019 Joao Medeiros Pereira. All rights reserved.
//

import UIKit
import Lottie
import Hero
import StepView

protocol INVSSimutatorViewControlerProtocol: class {
    func displayNextTextField(withLastTextField textField: INVSFloatingTextField)
    func displayReview(withTextFields textFields: [INVSFloatingTextField])
    func displaySimulationProjection(with simulatorModel: INVSSimulatorModel)
    func displayErrorSimulationProjection(with messageError:String, shouldHideAutomatically:Bool, popupType: INVSPopupMessageType, sender: UIView?)
    func displayInfo(withMessage message: String, title: String, shouldHideAutomatically: Bool)
    func displayOkAction(withTextField textField:INVSFloatingTextField, andShouldResign shouldResign: Bool)
    func displayCancelAction()
    func displayLogout()
}

public class INVSSimutatorViewControler: UIViewController {
    @IBOutlet weak var helpView: INVSSimulatorHelpView!
    @IBOutlet weak var helpViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var initialValueTextField: INVSFloatingTextField!
    @IBOutlet weak var monthValueTextField: INVSFloatingTextField!
    @IBOutlet weak var interestRateTextField: INVSFloatingTextField!
    @IBOutlet weak var totalMonthsTextField: INVSFloatingTextField!
    @IBOutlet weak var initialMonthlyRescueTextField: INVSFloatingTextField!
    @IBOutlet weak var increaseRescueTextField: INVSFloatingTextField!
    @IBOutlet weak var goalIncreaseRescueTextField: INVSFloatingTextField!
    @IBOutlet weak var saveButton: UIButton!
    private var saveButtonLayer: CAGradientLayer!
    @IBOutlet weak var clearButton: UIButton!
    private var clearButtonLayer: CAGradientLayer!
    @IBOutlet weak var horizontalStackView: UIStackView!
    @IBOutlet weak var heightScrollView: NSLayoutConstraint!
    let animatedLogoView = AnimationView(frame: .zero)
    
    var popupMessage: INVSPopupMessage?
    var interactor: INVSSimulatorInteractorProtocol?
    let router = INVSRouter()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        title = "Simulação"
        let interactor = INVSSimulatorInteractor()
        interactor.allTextFields = [initialValueTextField, monthValueTextField, interestRateTextField, totalMonthsTextField, initialMonthlyRescueTextField, increaseRescueTextField, goalIncreaseRescueTextField]
        self.interactor = interactor
        let presenter = INVSSimulatorPresenter()
        presenter.controller = self
        interactor.presenter = presenter
        helpView.interactor = self.interactor
        if INVSSession.session.isDev() {
            mockInfo()
        }
        setupUI()
        setLeftBarButton()
        setRightBarButton()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        popupMessage = INVSPopupMessage(parentViewController: self)
        initialValueTextField.delegate = self
        updateUI()
    }
    
    public func mockInfo() {
        initialValueTextField.floatingTextField.text = "R$50.000,00"
        monthValueTextField.floatingTextField.text = "R$500,00"
        interestRateTextField.floatingTextField.text = "3,00%"
        totalMonthsTextField.floatingTextField.text = "60"
        initialMonthlyRescueTextField.floatingTextField.text = "R$300,00"
        increaseRescueTextField.floatingTextField.text = "R$200,00"
        goalIncreaseRescueTextField.floatingTextField.text = "R$500,00"
    }
    
    func setupUI() {
        setupTextFields()
        horizontalStackView.addBackground(color: .lightGray)
        view.backgroundColor = .INVSGray()
    }
    
    private func setupTextFields() {
        INVSFloatingTextFieldType.initialValue.setupTextField(withTextField: initialValueTextField, andDelegate: self, valueTypeTextField: .currency, isRequired: true)
        INVSFloatingTextFieldType.monthValue.setupTextField(withTextField: monthValueTextField, andDelegate: self, valueTypeTextField: .currency)
        INVSFloatingTextFieldType.interestRate.setupTextField(withTextField: interestRateTextField, andDelegate: self, valueTypeTextField: .percent, isRequired: true)
        INVSFloatingTextFieldType.totalMonths.setupTextField(withTextField: totalMonthsTextField, andDelegate: self, valueTypeTextField: .months, isRequired: true)
        INVSFloatingTextFieldType.initialMonthlyRescue.setupTextField(withTextField: initialMonthlyRescueTextField, andDelegate: self, valueTypeTextField: .currency, hasInfoButton: true)
        INVSFloatingTextFieldType.increaseRescue.setupTextField(withTextField: increaseRescueTextField, andDelegate: self, valueTypeTextField: .currency, hasInfoButton: true)
        INVSFloatingTextFieldType.goalIncreaseRescue.setupTextField(withTextField: goalIncreaseRescueTextField, andDelegate: self, valueTypeTextField: .currency, hasInfoButton: true)
    }
    
    func setLeftBarButton() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.shouldOpen))
        animatedLogoView.addGestureRecognizer(gesture)
        
        let starAnimation = Animation.named("closePlusAnimation")
        animatedLogoView.animation = starAnimation
        animatedLogoView.contentMode = .scaleAspectFit
        animatedLogoView.animationSpeed = 1.0
        animatedLogoView.loopMode = .loop
        animatedLogoView.alpha = 1.0
        openAnimation()
        let menuBarItem = UIBarButtonItem(customView: animatedLogoView)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        self.navigationItem.leftBarButtonItem = menuBarItem
    }
    
    func setRightBarButton() {
        
        let exitButton = UIButton(frame: .zero)
        exitButton.setImage(UIImage(named: "exitAppIconWhite"), for: .normal)
        exitButton.imageView?.contentMode = .scaleAspectFit
        exitButton.tintColor = .INVSDefault()
        exitButton.addTarget(self, action: #selector(logOut(_:)), for: .touchUpInside)
        
        
        let rightItem = UIBarButtonItem(customView: exitButton)
        let currWidth = rightItem.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = rightItem.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func logOut(_ sender: Any) {
        let logoutViewController = INVSAlertViewController()
        logoutViewController.setup(withHeight: 140, andWidth: 300, andCornerRadius: 8, andContentViewColor: .white)
        logoutViewController.titleAlert = INVSConstants.LogoutAlertViewController.title.rawValue
        logoutViewController.messageAlert = INVSConstants.LogoutAlertViewController.message.rawValue
        logoutViewController.view.frame = view.bounds
        logoutViewController.modalPresentationStyle = .overCurrentContext
        logoutViewController.view.backgroundColor = .clear
        present(logoutViewController, animated: true, completion: nil)
        logoutViewController.confirmCallback = { (button) -> () in
            logoutViewController.confirmButton.showLoading()
            self.interactor?.logout()
        }
    }
    
    @objc func willEnterForeground() {
        helpView.messageLabelType.setNextStep(helpView: helpView)
    }
    
    @objc func shouldOpen(sender : UITapGestureRecognizer) {
        helpView.isOpened ? closeAnimation() : openAnimation()
    }
    
    func openAnimation() {
        self.showHelpView()
        animatedLogoView.play(fromFrame: AnimationProgressTime(integerLiteral: 20), toFrame: AnimationProgressTime(integerLiteral: 70), loopMode: .playOnce) { (finished) in
            self.helpView.isOpened = true
        }
    }
    
    @objc func showHelpView() {
        view.endEditing(true)
        helpView.allTextfields = [INVSFloatingTextField]()
        helpView.stepView.moveTo(step: 1)
        helpViewTopConstraint.constant = 0
        helpView.investorTypeSegmentedControl.isHidden = true
        helpView.stepView.isHidden = true
        helpView.messageLabel.attributedString = NSAttributedString.init(string: "")
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.helpView.setInitialStep()
        }
    }
    
    func closeAnimation() {
        self.closeHelpView()
        animatedLogoView.play(fromFrame: AnimationProgressTime(integerLiteral: 110), toFrame: AnimationProgressTime(integerLiteral: 160), loopMode: .playOnce) { (finished) in
            self.helpView.isOpened = false
        }
    }
    
    func closeHelpView() {
        view.endEditing(true)
        helpView.isOpened = false
        helpViewTopConstraint.constant = helpViewTopConstraint.constant  - helpView.frame.height
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        interactor?.simulationProjection()
    }
    
    @IBAction func clearAction(_ sender: Any) {
        interactor?.clear()
    }
    
    private func updateUI() {
        UIView.animate(withDuration: 0.4) {
            self.saveButtonLayer = CAShapeLayer.addGradientLayer(withGradientLayer: self.saveButtonLayer, inView: self.saveButton, withColorsArr: UIColor.INVSGradientColors(),withRoundedCorner: 25)
            self.clearButtonLayer = CAShapeLayer.addGradientLayer(withGradientLayer: self.clearButtonLayer, inView: self.clearButton, withColorsArr: UIColor.INVSGradientColors(), withRoundedCorner: 25)
            self.view.layoutSubviews()
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        popupMessage?.layoutSubviews()
        
    }
    
    public override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        popupMessage?.hide()
        updateUI()
    }
    
}

extension INVSSimutatorViewControler: INVSFloatingTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: INVSFloatingTextField) {
        self.popupMessage?.hide()
    }
    func toolbarAction(_ textField: INVSFloatingTextField, typeOfAction type: INVSKeyboardToolbarButton) {
        interactor?.checkToolbarAction(withTextField: textField, typeOfAction: type)
    }
    
    func infoButtonAction(_ textField: INVSFloatingTextField) {
        view.endEditing(true)
        interactor?.showInfo(withSender: textField)
    }
    
}

extension INVSSimutatorViewControler: INVSSimutatorViewControlerProtocol {
    func displayNextTextField(withLastTextField textField: INVSFloatingTextField) {
        helpView.showNextStep(withLastTextField: textField)
    }
    
    func displayReview(withTextFields textFields: [INVSFloatingTextField]) {
        closeAnimation()
        interactor?.clear()
        for (index, textField) in textFields.enumerated() {
            interactor?.allTextFields[index].floatingTextField.text = textField.floatingTextField.text
        }
        setupUI()
        updateUI()
    }
    
    func displayOkAction(withTextField textField: INVSFloatingTextField, andShouldResign shouldResign: Bool) {
        textField.floatingTextField.becomeFirstResponder()
        if shouldResign {
            interactor?.simulationProjection()
            view.endEditing(shouldResign)
        }
    }

    func displayCancelAction() {
        view.endEditing(true)
    }
    
    func displaySimulationProjection(with simulatorModel: INVSSimulatorModel) {
        popupMessage?.hide()

        router.routeToSimulated(withViewController: self, fromButton: self.saveButton, andSimulatorModel: simulatorModel, heroId: INVSConstants.INVSTransactionsViewControllersID.startSimulatedViewController.rawValue)
    }
    
    func displayErrorSimulationProjection(with messageError:String, shouldHideAutomatically:Bool, popupType: INVSPopupMessageType, sender: UIView?) {
        popupMessage?.show(withTextMessage: messageError, popupType: popupType, shouldHideAutomatically: shouldHideAutomatically)
    }
    
    func displayInfo(withMessage message: String,title: String, shouldHideAutomatically: Bool) {
        popupMessage?.show(withTextMessage: message, title: title,popupType: .alert, shouldHideAutomatically: shouldHideAutomatically)
    }
    
    func displayLogout() {
        INVSKeyChainWrapper.clear()
        self.router.routeToLogin()
    }

}
