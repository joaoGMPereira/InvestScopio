//
//  SimulationCreationViewModel.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 07/09/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI
import JewFeatures

class SimulationCreationViewModel: NSObject, ObservableObject {
    
    //MARK: - Properties
    let tag = SimulationCreationViewModel.className
    @Published var simulation = INVSSimulatorModel()
    @Published var shouldSimulate: Bool = false
    
    //MARK: - TextField Properties
    @Published var close: Bool = false
    @Published var allSteps: Array<StepModel>
    @Published var shouldScrollBottom = false
    
    init(allSteps: Array<StepModel> = Array<StepModel>(repeating: StepModel(), count:  SimulationCreationViewType.allCases.count)) {
        self.allSteps = allSteps
    }
    
    func didBeginEditing(index: Int) {
        shouldScrollBottom = index > 3
    }
    
    func backStep(index: Int, completion: @escaping () -> Void) {
        completion()
        if allSteps.indices.contains(index - 1) {
            allSteps[index - 1].shouldBecomeFirstResponder = true
        }
        allSteps[index].shouldBecomeFirstResponder = false
    }
    
    func updateStep(textField: JEWFloatingTextField, text: String, index: Int) {
        allSteps[index].value = text
    }
    
    func nextStep(textField: JEWFloatingTextField, index: Int, completion: @escaping () -> Void, failure: @escaping (AppPopupSettings) -> Void) {
        completion()
        allSteps[index].shouldBecomeFirstResponder = false
        if allSteps.indices.contains(index + 1) {
            allSteps[index + 1].shouldBecomeFirstResponder = true
        }
    }
    
    func selectFirstButton(completion: @escaping (INVSSimulatorModel) -> Void, failure: @escaping (AppPopupSettings) -> Void) {
        guard isValidRequiredSteps() else {
            failure(AppPopupSettings.init(message: "Prencha todos os campos obrigatórios com um valor maior que zero para prosseguir!", textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true))
            return
        }
        if isValidNotRequiredSteps(failure: failure) {
            fillSimulation()
            completion(simulation)
            shouldSimulate = true
            cleanTextFields()
        }
    }
    
    private func fillSimulation() {
        for(index, step) in allSteps.enumerated() {
            allSteps[index].hasError = false
            switch step.type {
            case .initialStep, .lastStep: break
            case .firstStep:
                simulation.initialValue = step.value.convertFormattedToDouble()
            case .secondStep:
                simulation.monthValue = step.value.convertFormattedToDouble()
            case .thirdStep:
                simulation.interestRate = step.value.convertFormattedToDouble()
            case .fourthStep:
                simulation.totalMonths = step.value.convertFormattedToInt()
            case .fifthStep:
                simulation.initialMonthlyRescue = step.value.convertFormattedToDouble()
            case .sixthStep:
                simulation.increaseRescue = step.value.convertFormattedToDouble()
            case .seventhStep:
                simulation.goalIncreaseRescue = step.value.convertFormattedToDouble()
            }
        }
    }
    
    private func isValidRequiredSteps() -> Bool {
        var validRequiredSteps = true
        for (index, step) in allSteps.enumerated() {
            if step.isRequired {
                if step.value.isEmpty || step.value.convertFormattedToDouble() <= 0 {
                    allSteps[index].hasError = true
                    validRequiredSteps = false
                } else {
                    allSteps[index].hasError = false
                }
            }
        }
        return validRequiredSteps
    }
    
    private func isValidNotRequiredSteps(failure: @escaping (AppPopupSettings) -> Void) -> Bool {
        var validRequiredSteps = true
        for (index, step) in allSteps.enumerated() {
            switch step.type {
            case .seventhStep:
                if allSteps.indices.contains(allSteps.count - 1) {
                    let sixthStep = allSteps[allSteps.count - 2]
                    if step.value.convertFormattedToDouble() < sixthStep.value.convertFormattedToDouble() {
                        allSteps[index].hasError = true
                        validRequiredSteps = false
                        failure(AppPopupSettings(message: "É necessário que o valor do \"\(step.key)\" seja maior ou igual ao valor do \"\(sixthStep.key)\"", textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true))
                    } else {
                        allSteps[index].hasError = false
                    }
                }
            default:
                if !step.value.isEmpty && step.value.convertFormattedToDouble() <= 0 {
                    allSteps[index].hasError = true
                    validRequiredSteps = false
                    failure(AppPopupSettings(message: "Caso preencha um campo não obrigatório, é necessário que seja maior que zero, no contrário deixe em branco.", textColor: .white, backgroundColor: Color(.JEWRed()), position:
                        .top, show: true))
                } else {
                    allSteps[index].hasError = false
                }
            }
        }
        return validRequiredSteps
    }
    
    func selectSecondButton(completion: @escaping () -> Void) {
        cleanTextFields()
    }
    
    private func cleanTextFields() {
        close = true
        simulation = INVSSimulatorModel()
        for (index, _) in allSteps.enumerated() {
            allSteps[index].value = String()
            allSteps[index].shouldBecomeFirstResponder = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.close = false
        }
    }
}
