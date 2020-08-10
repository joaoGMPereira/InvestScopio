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
    
    @Published var simulations = [INVSSimulatorModel]()
    @Published var simulationsLoadable: Loadable<[INVSSimulatorModel]> {
        didSet {
            build(state: simulationsLoadable)
        }
    }
    @Published var showLoading = false
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
            self.showLoading = true
            //Show Loading
            break
        case .loaded(let response):
            //self.messageSuccess = respons
            self.showSuccess = true
            self.showError = false
            self.showLoading = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.close = true
                self.showSuccess = false
            }
            
        case .failed(let error):
            if let apiError = error as? APIError {
                self.messageError = apiError.errorDescription ?? String()
                self.showError = true
            }
            self.showLoading = false
            //Show Alert
            break
        }
    }
}
