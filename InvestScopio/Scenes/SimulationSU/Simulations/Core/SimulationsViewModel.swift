//
//  RegisterViewModel.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 20/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import SwiftUI

class SimulationsViewModel: ObservableObject {
    
    @Published var simulations = INVSSimulatorModel.simulationsTeste
    @Published var simulationsLoadable: Loadable<[INVSSimulatorModel]> {
        didSet {
            build(state: simulationsLoadable)
        }
    }
    @Published var state: ViewState = .loading
    @Published var showError = false
    @Published var showSuccess = false
    @Published var close = true
    @Published var messageError = String()
    @Published var messageSuccess = String()
    
    let simulationsService: SimulationsServiceProtocol

    init(service: SimulationsServiceProtocol) {
        self._simulationsLoadable = .init(initialValue: .notRequested)
        self.simulationsService = service
    }
    
    func getSimulations() {
        switch simulationsLoadable {
        case .notRequested, .loaded(_), .failed(_):
            simulationsService
                .load(simulations: loadableSubject(\.simulationsLoadable))
            
        case .isLoading(_, _): break
            //aguarde um momento
        }
    }
    
    func build(state: Loadable<[INVSSimulatorModel]>) {
        switch state {
        case .notRequested:
            break
            
        case .isLoading(_, _):
            self.showError = false
            self.state = .loading

            break
        case .loaded(let response):
            self.simulations = response
            self.showError = false
            self.state = .loaded
        case .failed(let error):
            if let apiError = error as? APIError {
                self.messageError = apiError.errorDescription ?? String()
                self.showError = true
            }
            self.state = .loaded
            break
        }
    }
}
