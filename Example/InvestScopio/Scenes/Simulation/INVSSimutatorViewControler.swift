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
protocol INVSSimutatorViewControlerProtocol: class {
    func displaySimulationProjection(with simulatedValues: [INVSSimulatedValueModel])
    func displayLoading()
    func dismissLoading()
    func displayErrorSimulationProjection(with messageError:String, shouldHideAutomatically:Bool, popupType: INVSPopupMessageType, sender: UIView?)
    func displayInfo(withMessage message: String, title: String, shouldHideAutomatically: Bool, sender: UIView)
    func displayOkAction(withTextField textField:INVSFloatingTextField, andShouldResign shouldResign: Bool)
    func displayCancelAction()
}

public class INVSSimutatorViewControler: UIViewController {
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
    var loadingView = AnimationView()
    @IBOutlet weak var heightScrollView: NSLayoutConstraint!
    
    
    var popupMessage: INVSPopupMessage?
    var interactor: INVSSimulatorInteractorProtocol?
    let router = INVSRouter()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        title = "Simulação"
        let interactor = INVSSimulatorInteractor()
        interactor.allTextFields = [initialValueTextField, monthValueTextField, interestRateTextField, totalMonthsTextField, initialMonthlyRescueTextField, increaseRescueTextField, goalIncreaseRescueTextField]
        self.interactor = interactor
        let presenter = INVSSimulatorPresenter()
        presenter.controller = self
        interactor.presenter = presenter
        mockInfo()
        setupUI()
    }
    
    public func mockInfo() {
        initialValueTextField.floatingTextField.text = "R$50.000,00"
        monthValueTextField.floatingTextField.text = "R$500,00"
        interestRateTextField.floatingTextField.text = "3,00%"
        totalMonthsTextField.floatingTextField.text = "20"
        initialMonthlyRescueTextField.floatingTextField.text = "R$100,00"
        increaseRescueTextField.floatingTextField.text = "R$100,00"
        goalIncreaseRescueTextField.floatingTextField.text = "R$1.000,00"
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        popupMessage = INVSPopupMessage(parentViewController: self)
        updateUI()

    }
    
    func setupUI() {
        setupTextFields()
        setupLoading()
        horizontalStackView.addBackground(color: .lightGray)
        view.backgroundColor = .INVSGray()
    }
    
    func setupLoading() {
        saveButton.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.centerYAnchor.constraint(equalTo: saveButton.safeAreaLayoutGuide.centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 50),
            loadingView.heightAnchor.constraint(equalToConstant: 50),
            loadingView.centerXAnchor.constraint(equalTo: saveButton.safeAreaLayoutGuide.centerXAnchor),
            
            ])
        let starAnimation = Animation.named("animatedLoadingWhite")
        loadingView.animation = starAnimation
        loadingView.contentMode = .scaleAspectFit
        loadingView.animationSpeed = 1.0
        loadingView.loopMode = .loop
        loadingView.isHidden = true

    }
    
    private func setupTextFields() {
        initialValueTextField.setup(placeholder: "Valor Inicial", typeTextField: .initialValue, valueTypeTextField: .currency, required: true, color: UIColor.INVSDefault())
        initialValueTextField.delegate = self
        
        monthValueTextField.setup(placeholder: "Investimento Mensal", typeTextField: .monthValue, valueTypeTextField: .currency, required: false, color: UIColor.INVSDefault())
        monthValueTextField.delegate = self
        
        interestRateTextField.setup(placeholder: "Taxa de Juros", typeTextField: .interestRate, valueTypeTextField: .percent, required: true, color: UIColor.INVSDefault())
        interestRateTextField.delegate = self
        
        totalMonthsTextField.setup(placeholder: "Total de Meses", typeTextField: .totalMonths, valueTypeTextField: .months, required: true, color: UIColor.INVSDefault())
        totalMonthsTextField.delegate = self
        
        initialMonthlyRescueTextField.setup(placeholder: "Valor Inicial do Resgate", typeTextField: .initialMonthlyRescue, valueTypeTextField: .currency, hasInfoButton: true, color: UIColor.INVSDefault())
        initialMonthlyRescueTextField.delegate = self
        
        increaseRescueTextField.setup(placeholder: "Acréscimo no resgate", typeTextField: .increaseRescue, valueTypeTextField: .currency, hasInfoButton: true, color: UIColor.INVSDefault())
        increaseRescueTextField.delegate = self
        
        goalIncreaseRescueTextField.setup(placeholder: "Objetivo de rendimento para aumento de resgate", typeTextField: .goalIncreaseRescue, valueTypeTextField: .currency, hasInfoButton: true, color: UIColor.INVSDefault())
        goalIncreaseRescueTextField.delegate = self
    }
    
    @IBAction func saveAction(_ sender: Any) {
        interactor?.simulationProjection()
    }
    @IBAction func clearAction(_ sender: Any) {
        interactor?.clear()
    }
    
    private func disableButtonsAction() {
        self.saveButton.isEnabled = false
        self.clearButton.isEnabled = false
    }
    
    private func enableButtonsAction() {
        self.saveButton.isEnabled = true
        self.clearButton.isEnabled = true
    }
    
    private func updateUI() {
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            heightScrollView.constant = view.frame.height * 0.4
        } else {
            heightScrollView.constant = view.frame.height * 0.5
        }
        UIView.animate(withDuration: 0.4) {
            self.saveButtonLayer = CAShapeLayer.addGradientLayer(withGradientLayer: self.saveButtonLayer, inView: self.saveButton, withColorsArr: UIColor.INVSGradientColors())
            self.clearButtonLayer = CAShapeLayer.addGradientLayer(withGradientLayer: self.clearButtonLayer, inView: self.clearButton, withColorsArr: UIColor.INVSGradientColors())
            self.view.layoutSubviews()
        }
    }
    
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        popupMessage?.layoutSubviews()
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            print(keyboardHeight)
        }
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
        interactor?.showInfo(nearOfSender: textField)
    }
    
}

extension INVSSimutatorViewControler: INVSSimutatorViewControlerProtocol {

    func displayOkAction(withTextField textField: INVSFloatingTextField, andShouldResign shouldResign: Bool) {
        textField.floatingTextField.becomeFirstResponder()
        if shouldResign {
            if saveButton.isEnabled {
                interactor?.simulationProjection()
            }
            view.endEditing(shouldResign)
        }
    }
    
    func displayLoading() {
        saveButton.setTitle("", for: .normal)
        disableButtonsAction()
        loadingView.isHidden = false
        loadingView.play()
    }
    func dismissLoading() {
        loadingView.isHidden = true
        loadingView.stop()
        enableButtonsAction()
        saveButton.setTitle("Simular", for: .normal)
    }
    func displayCancelAction() {
        view.endEditing(true)
    }
    
    func displaySimulationProjection(with simulatedValues: [INVSSimulatedValueModel]) {
        popupMessage?.hide()
        enableButtonsAction()
        router.routeToSimulated(withSimulatorViewController: self, andSimulatedValues: simulatedValues)
    }
    
    func displayErrorSimulationProjection(with messageError:String, shouldHideAutomatically:Bool, popupType: INVSPopupMessageType, sender: UIView?) {
        popupMessage?.show(withTextMessage: messageError, popupType: popupType, shouldHideAutomatically: shouldHideAutomatically, sender: sender)
    }
    
    func displayInfo(withMessage message: String,title: String, shouldHideAutomatically: Bool, sender: UIView) {
        popupMessage?.show(withTextMessage: message, title: title,popupType: .alert, shouldHideAutomatically: shouldHideAutomatically)
    }
    
    
    
}
