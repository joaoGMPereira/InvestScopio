//
//  StepModel.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 07/09/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation

class StepModel {
    var key: String
    var value: String
    var type: SimulationCreationViewType
    var isRequired: Bool
    
    init(key: String = String(), value: String = String(), type: SimulationCreationViewType = .initialStep, isRequired: Bool = false) {
        self.key = key
        self.value = value
        self.type = type
        self.isRequired = isRequired
    }
    
    static var allDefaultSteps: Array<StepModel> {
        var steps = [StepModel]()
        SimulationCreationViewType.allCases.forEach { (type) in
            var isRequired = true
            
            switch type {
            case .thirdStep, .fifthStep, .sixthStep, .seventhStep:
                isRequired = false
            default:
                break
            }
            
            let step = StepModel(key: type.setNextStepPlaceHolder(), type: type, isRequired: isRequired)
            
            switch type {
            case .firstStep, .secondStep, .thirdStep, .fourthStep, .fifthStep, .sixthStep, .seventhStep:
                steps.append(step)
            default:
                break
            }
        }
        return steps
    }
}
