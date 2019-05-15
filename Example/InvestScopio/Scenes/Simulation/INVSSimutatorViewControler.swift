//
//  ViewController.swift
//  InvestEx
//
//  Created by Joao Medeiros Pereira on 05/10/2019.
//  Copyright (c) 2019 Joao Medeiros Pereira. All rights reserved.
//

import UIKit

protocol INVSSimutatorViewControlerProtocol: class {
    func displaySimulationProjection(with simulatedValues: [INVSSimulatedValueModel])
    func displayErrorSimulationProjection(with messageError: String)
    func displayInfo(withMessage message: String, shouldHideAutomatically: Bool, sender: UIView)
    func displayOkAction(withTextField textField:INVSFloatingTextField, andShouldResign shouldResign: Bool)
    func displayCancelAction()
    func displayClear()
}

public class INVSSimutatorViewControler: UIViewController {
    @IBOutlet weak var initialValueTextField: INVSFloatingTextField!
    @IBOutlet weak var monthValueTextField: INVSFloatingTextField!
    @IBOutlet weak var interestRateTextField: INVSFloatingTextField!
    @IBOutlet weak var totalMonthsTextField: INVSFloatingTextField!
    @IBOutlet weak var monthlyRescueTextField: INVSFloatingTextField!
    @IBOutlet weak var increaseRescueTextField: INVSFloatingTextField!
    @IBOutlet weak var goalIncreaseRescueTextField: INVSFloatingTextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var horizontalStackView: UIStackView!
    
    var popupMessage: INVSPopupMessage?
    var dataSource = INVSSimulatorTableviewDataSourceDelegate()
    var interactor: INVSSimulatorInteractorProtocol?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let interactor = INVSSimulatorInteractor()
        interactor.allTextFields = [initialValueTextField, monthValueTextField, interestRateTextField, totalMonthsTextField, monthlyRescueTextField, increaseRescueTextField, goalIncreaseRescueTextField]
        self.interactor = interactor
        let presenter = INVSSimulatorPresenter()
        presenter.controller = self
        interactor.presenter = presenter
        setupUI()
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        popupMessage = INVSPopupMessage(parentViewController: self)
    }
    
    func setupUI() {
        horizontalStackView.addBackground(color: .lightGray)
        initialValueTextField.setup(placeholder: "Valor Inicial", typeTextField: .initialValue, valueTypeTextField: .currency, required: true, color: UIColor.INVSDefault())
        initialValueTextField.delegate = self
        
        monthValueTextField.setup(placeholder: "Valor do Aporte", typeTextField: .monthValue, valueTypeTextField: .currency, required: false, color: UIColor.INVSDefault())
        monthValueTextField.delegate = self
        
        interestRateTextField.setup(placeholder: "Taxa de Juros", typeTextField: .interestRate, valueTypeTextField: .percent, required: true, color: UIColor.INVSDefault())
        interestRateTextField.delegate = self
        
        totalMonthsTextField.setup(placeholder: "Total de Meses", typeTextField: .totalMonths, valueTypeTextField: .months, required: true, color: UIColor.INVSDefault())
        totalMonthsTextField.delegate = self
        
        monthlyRescueTextField.setup(placeholder: "Resgate Mensal Inicial", typeTextField: .initialMonthlyRescue, valueTypeTextField: .currency, hasInfoButton: true, color: UIColor.INVSDefault())
        monthlyRescueTextField.delegate = self
        
        increaseRescueTextField.setup(placeholder: "Aumento no Resgate", typeTextField: .increaseRescue, valueTypeTextField: .currency, color: UIColor.INVSDefault())
        increaseRescueTextField.delegate = self
        
        goalIncreaseRescueTextField.setup(placeholder: "Valor para aumentar o Resgate", typeTextField: .goalIncreaseRescue, valueTypeTextField: .currency, color: UIColor.INVSDefault())
        goalIncreaseRescueTextField.delegate = self
        
        saveButton.backgroundColor = UIColor.INVSDefault()
        clearButton.backgroundColor = UIColor.INVSDefault()
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: INVSConstants.SimulatorCellConstants.cellIdentifier.rawValue, bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: INVSConstants.SimulatorCellConstants.cellIdentifier.rawValue)
        
    }
    
    private func reloadTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.reloadData()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        interactor?.simulationProjection()
    }
    @IBAction func clearAction(_ sender: Any) {
        interactor?.clear()
    }
}

extension INVSSimutatorViewControler: INVSFloatingTextFieldDelegate {
    func toolbarAction(_ textField: INVSFloatingTextField, typeOfAction type: INVSKeyboardToolbarButton) {
        interactor?.checkToolbarAction(withTextField: textField, typeOfAction: type)
    }
    
    func infoButtonAction(_ textField: INVSFloatingTextField) {
        interactor?.showInfo(nearOfSender: textField)
    }
    
}

extension INVSSimutatorViewControler: INVSSimutatorViewControlerProtocol {

    func displayOkAction(withTextField textField: INVSFloatingTextField, andShouldResign shouldResign: Bool) {
        textField.floatingTextField.becomeFirstResponder()
        if shouldResign {
            view.endEditing(shouldResign)
        }
    }
    func displayCancelAction() {
        view.endEditing(true)
    }
    
    func displaySimulationProjection(with simulatedValues: [INVSSimulatedValueModel]) {
        dataSource.simulatedValues = simulatedValues
        reloadTableView()
    }
    
    func displayErrorSimulationProjection(with messageError: String) {
        popupMessage?.show(withTextMessage: messageError)
    }
    
    func displayInfo(withMessage message: String, shouldHideAutomatically: Bool, sender: UIView) {
        popupMessage?.show(withTextMessage: message,popupType: .alert, shouldHideAutomatically: shouldHideAutomatically, sender: sender)
    }
    
    func displayClear() {
        dataSource.simulatedValues = [INVSSimulatedValueModel]()
        reloadTableView()
    }
    
}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
