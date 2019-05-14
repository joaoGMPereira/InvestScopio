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
    @IBOutlet weak var monthlyRescueTextField: INVSFloatingTextField!
    @IBOutlet weak var increaseRescueTextField: INVSFloatingTextField!
    @IBOutlet weak var goalIncreaseRescueTextField: INVSFloatingTextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var popupMessage: INVSPopupMessage?
    var allTextFields = [INVSFloatingTextField]()
    
    var interactor: INVSSimulatorInteractorProtocol?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let interactor = INVSSimulatorInteractor()
        self.interactor = interactor
        let presenter = INVSSimulatorPresenter()
        presenter.controller = self
        interactor.presenter = presenter
        setupUI()
        
    }
    
    func setupUI() {
        initialValueTextField.setup(placeholder: "Valor Inicial*", typeTextField: .currency, required: true, color: UIColor.INVSDefault())
        monthValueTextField.setup(placeholder: "Valor do Aporte*", typeTextField: .currency, required: true, color: UIColor.INVSDefault())
        interestRateTextField.setup(placeholder: "Taxa de Juros*", typeTextField: .percent, required: true, color: UIColor.INVSDefault())
        monthlyRescueTextField.setup(placeholder: "Resgate Mensal Inicial", typeTextField: .currency, color: UIColor.INVSDefault())
        increaseRescueTextField.setup(placeholder: "Aumento no Resgate", typeTextField: .currency, color: UIColor.INVSDefault())
        goalIncreaseRescueTextField.setup(placeholder: "Valor para aumentar o Resgate", typeTextField: .currency, color: UIColor.INVSDefault())
        
        allTextFields.append(contentsOf: [initialValueTextField, monthValueTextField, interestRateTextField, monthlyRescueTextField, increaseRescueTextField, goalIncreaseRescueTextField])
        
        saveButton.backgroundColor = UIColor.INVSDefault()
        clearButton.backgroundColor = UIColor.INVSDefault()
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        popupMessage = INVSPopupMessage(parentViewController: self)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        interactor?.simulationProjection(with: allTextFields)
    }
}

extension INVSSimutatorViewControler: INVSSimutatorViewControlerProtocol {
    
    func displaySimulationProjection() {
        
    }
    
    func displayErrorSimulationProjection(with messageError: String) {
        popupMessage?.show(withTextMessage: messageError)
        
    }
    
}
