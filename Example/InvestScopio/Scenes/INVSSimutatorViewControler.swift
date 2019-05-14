//
//  ViewController.swift
//  InvestEx
//
//  Created by Joao Medeiros Pereira on 05/10/2019.
//  Copyright (c) 2019 Joao Medeiros Pereira. All rights reserved.
//

import UIKit

protocol INVSSimutatorViewControlerProtocol: class {
    func displaySimulationProjection()
    func displayErrorSimulationProjection(with messageError: String)
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
    var popupMessage: INVSPopupMessage?
    
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
    
    func setupUI() {
        initialValueTextField.setup(placeholder: "Valor Inicial", typeTextField: .initialValue, valueTypeTextField: .currency, required: true, color: UIColor.INVSDefault())
        monthValueTextField.setup(placeholder: "Valor do Aporte", typeTextField: .monthValue, valueTypeTextField: .currency, required: true, color: UIColor.INVSDefault())
        interestRateTextField.setup(placeholder: "Taxa de Juros", typeTextField: .interestRate, valueTypeTextField: .percent, required: true, color: UIColor.INVSDefault())
        totalMonthsTextField.setup(placeholder: "Total de Meses", typeTextField: .totalMonths, valueTypeTextField: .months, required: true, color: UIColor.INVSDefault())
        monthlyRescueTextField.setup(placeholder: "Resgate Mensal Inicial", typeTextField: .monthlyRescue, valueTypeTextField: .currency, color: UIColor.INVSDefault())
        increaseRescueTextField.setup(placeholder: "Aumento no Resgate", typeTextField: .increaseRescue, valueTypeTextField: .currency, color: UIColor.INVSDefault())
        goalIncreaseRescueTextField.setup(placeholder: "Valor para aumentar o Resgate", typeTextField: .goalIncreaseRescue, valueTypeTextField: .currency, color: UIColor.INVSDefault())
        
        saveButton.backgroundColor = UIColor.INVSDefault()
        clearButton.backgroundColor = UIColor.INVSDefault()
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        popupMessage = INVSPopupMessage(parentViewController: self)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        interactor?.simulationProjection()
    }
    @IBAction func clearAction(_ sender: Any) {
        interactor?.clearTextFields()
    }
}

extension INVSSimutatorViewControler: INVSSimutatorViewControlerProtocol {
    
    func displaySimulationProjection() {
        
    }
    
    func displayErrorSimulationProjection(with messageError: String) {
        popupMessage?.show(withTextMessage: messageError)
        
    }
    
}
