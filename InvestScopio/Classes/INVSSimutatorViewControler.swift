//
//  ViewController.swift
//  InvestEx
//
//  Created by Joao Medeiros Pereira on 05/10/2019.
//  Copyright (c) 2019 Joao Medeiros Pereira. All rights reserved.
//

import UIKit


public class INVSSimutatorViewControler: UIViewController {
    @IBOutlet weak var initialValueTextField: INVSFloatingTextField!
    @IBOutlet weak var monthValueTextField: INVSFloatingTextField!
    @IBOutlet weak var interestRateTextField: INVSFloatingTextField!
    @IBOutlet weak var monthlyRescueTextField: INVSFloatingTextField!
    @IBOutlet weak var increaseRescueTextField: INVSFloatingTextField!
    @IBOutlet weak var goalIncreaseRescueTextField: INVSFloatingTextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        initialValueTextField.setup(placeholder: "Valor Inicial", color: UIColor.INVSDefault())
        monthValueTextField.setup(placeholder: "Valor do Aporte", color: UIColor.INVSDefault())
        interestRateTextField.setup(placeholder: "Taxa de Juros", color: UIColor.INVSDefault())
        monthlyRescueTextField.setup(placeholder: "Resgate Mensal Inicial", color: UIColor.INVSDefault())
        increaseRescueTextField.setup(placeholder: "Aumento no Resgate", color: UIColor.INVSDefault())
        goalIncreaseRescueTextField.setup(placeholder: "Valor para aumentar o Resgate", color: UIColor.INVSDefault())
        
        saveButton.backgroundColor = UIColor.INVSDefault()
        clearButton.backgroundColor = UIColor.INVSDefault()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

