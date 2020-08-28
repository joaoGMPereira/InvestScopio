//
//  SimulationCreationViewModel.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 27/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation

class SimulationCreationViewModel: ObservableObject {
    @Published var step = SimulationCreationViewType.initialStep
}
