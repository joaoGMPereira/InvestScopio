//
//  SimulationCreationViewModel.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 07/09/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation

class SimulationCreationViewModel: ObservableObject {
    
    //MARK: - TextField Properties
    @Published var close: Bool = false
    @Published var allSteps: Array<StepModel>
    
    init(allSteps: Array<StepModel> = Array<StepModel>(repeating: StepModel(), count:  SimulationCreationViewType.allCases.count)) {
        self.allSteps = allSteps
    }
}
