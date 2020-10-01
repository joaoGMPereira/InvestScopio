//
//  SimulationCreationViewModel.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 27/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import JewFeatures

class SimulationCreationStepViewModel: ObservableObject {
    
    //MARK: - Step Properties
    @Published var showHeader: Bool = false
    @Published var showTextField: Bool = false
    @Published var showBottomButtons: Bool = false
    @Published var step = SimulationCreationViewType.initialStep
    @Published var textHeight: CGFloat = 44
    
    @Published var passed: Int = 0
    @Published var progress: Int = 0
    @Published var quantity: CGFloat =
    7
    @Published var firstButtonTitle = String()
    @Published var secondButtonTitle = String()
    
    @Published var rects = Array<CGRect>(repeating: CGRect(), count: CreateSimulationSegments.allLocalizedText.count)
    @Published var titles : [String] = CreateSimulationSegments.allLocalizedText
    
    @Published var selectedIndex: Int = 0 {
        didSet {
            segmentSelected = CreateSimulationSegments(rawValue: selectedIndex) ?? .simply
        }
    }
    
    @Published var isOpened: Bool = false {
        didSet {
            if oldValue == false || isOpened == false {
                cleanStep()
            }
        }
    }
    
    private var segmentSelected: CreateSimulationSegments = .simply {
        didSet {
            if segmentSelected == .simply {
                setSimplySteps()
            } else {
                setCompleteSteps()
            }
        }
    }
    
    //MARK: - TextField Properties
    @Published var close: Bool = false
    @Published var allSteps = Array<StepModel>(repeating: StepModel(), count:  SimulationCreationViewType.allCases.count)
}

//MARK: - Step Methods
extension SimulationCreationStepViewModel {
    func cleanStep() {
        segmentSelected = .simply
        step = .initialStep
        showHeader = false
        showTextField = false
        showBottomButtons = true
        allSteps = Array<StepModel>(repeating: StepModel(), count:  SimulationCreationViewType.allCases.count)
        firstButtonTitle = "Completa"
        secondButtonTitle = "Simplificada"
    }
    
    func setFirstStep() {
        passed = 0
        progress = 1
        step = .firstStep
        showHeader = true
        showTextField = true
        showBottomButtons = false
        allSteps = Array<StepModel>(repeating: StepModel(), count:  SimulationCreationViewType.allCases.count)
    }
    
    func setSimplySteps() {
        setFirstStep()
        quantity = 4
    }
    
    func setCompleteSteps() {
        setFirstStep()
        quantity = 7
    }
    
    func backStep(completion: @escaping () -> Void) {
        completion()
        allSteps[step.rawValue] = StepModel()
        step = SimulationCreationViewType.init(rawValue: step.rawValue - 1) ?? .initialStep
        if step == .initialStep {
            cleanStep()
            return
        }
        progress = step.rawValue
        passed = progress - 1
        
    }
    
    func updateStep(textField: JEWFloatingTextField, text: String) {
        let stepModel = StepModel(key: textField.placeHolderText, value: text, type: step, isRequired: step.isRequired())
        allSteps[step.rawValue] = stepModel
    }
    
    func nextStep(textField: JEWFloatingTextField, completion: @escaping () -> Void, failure: @escaping (AppPopupSettings) -> Void) {
        let stepModel = StepModel(key: textField.placeHolderText, value: textField.textFieldText, type: step, isRequired: step.isRequired())
        guard isValidRequiredStep(stepModel: stepModel) else {
            failure(AppPopupSettings.init(message: "O campo \"\(textField.placeHolderText)\" é obrigatório, preencha com um valor maior que zero para prosseguir!", textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true))
            return
        }
        if isValidNotRequiredStep(stepModel: stepModel, failure: failure) {
            allSteps[step.rawValue] = stepModel
            updateStep()
            updateToLastStep()
            
            completion()
        }
    }
    
    private func isValidRequiredStep(stepModel: StepModel) -> Bool {
        if stepModel.isRequired {
            if stepModel.value.isEmpty || stepModel.value.convertFormattedToDouble() <= 0 {
                return false
            }
            return true
        }
        return true
    }
    
    private func isValidNotRequiredStep(stepModel: StepModel, failure: @escaping (AppPopupSettings) -> Void) -> Bool {
        switch stepModel.type {
        case .seventhStep:
            if allSteps.indices.contains(stepModel.type.rawValue - 1) {
                let sixthStep = allSteps[stepModel.type.rawValue - 1]
                if stepModel.value.convertFormattedToDouble() < sixthStep.value.convertFormattedToDouble() {
                    failure(AppPopupSettings(message: "É necessário que o valor do \"\(stepModel.key)\" seja maior ou igual ao valor do \"\(sixthStep.key)\"", textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true))
                    return false
                }
            }
        default:
            if !stepModel.value.isEmpty && stepModel.value.convertFormattedToDouble() <= 0 {
                failure(AppPopupSettings(message: "Caso preencha o campo \"\(stepModel.key)\" é necessário que seja maior que zero, no contrário deixe em branco.", textColor: .white, backgroundColor: Color(.JEWRed()), position:
                    .top, show: true))
                return false
            }
        }
        return true
    }
    
    private func updateStep() {
        if step.rawValue == Int(self.quantity) {
            step = .lastStep
        } else {
            step = SimulationCreationViewType.init(rawValue: step.rawValue + 1) ?? .firstStep
            progress = step.rawValue
            passed = progress - 1
        }
    }
    
    private func updateToLastStep() {
        if step == .lastStep {
            showTextField = false
            showBottomButtons = true
            firstButtonTitle = "Conferir"
            secondButtonTitle = "Simular"
        }
    }
    
    func selectFirstButton(completion: @escaping (_ allSteps: [StepModel]) -> Void) {
        if step == .initialStep {
            selectedIndex = 0
        }
        
        if step == .lastStep {
            completion(allSteps)
            self.isOpened = false
        }
    }
    
    func check(completion: @escaping (_ allSteps: [StepModel]) -> Void) {
        if step == .initialStep {
            selectedIndex = 1
        }
        
        if step == .lastStep {
            completion(allSteps)
            self.isOpened = false
        }
    }
}
