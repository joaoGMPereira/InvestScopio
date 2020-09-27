//
//  RegisterViewModel.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 20/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import SwiftUI
import JewFeatures

class SimulationsViewModel: ObservableObject {
    
    @Published var simulations = INVSSimulatorModel.simulationsPlaceholders
    @Published var simulationsLoadable: Loadable<[INVSSimulatorModel]> {
        didSet {
            build(state: simulationsLoadable)
        }
    }
    @Published var deleteSimulationAllLoadable: Loadable<DeleteSimulationModel> {
        didSet {
            buildDeleteAllSimulations(state: deleteSimulationAllLoadable)
        }
    }
    @Published var deleteSimulationLoadable: Loadable<DeleteSimulationModel> {
        didSet {
            buildDeleteSimulation(state: deleteSimulationLoadable)
        }
    }
    @Published var deleteState = DeleteState()
    @Published var state: ViewState = .loading
    @Published var reload = false
    @Published var message = String()
    
    let simulationsService: SimulationsServiceProtocol
    var completion: (() -> Void)?
    var completionDelete: ((AppPopupSettings) -> Void)?
    var failure:((AppPopupSettings) -> Void)?
    
    init(service: SimulationsServiceProtocol) {
        self._simulationsLoadable = .init(initialValue: .notRequested)
        self._deleteSimulationAllLoadable = .init(initialValue: .notRequested)
        self._deleteSimulationLoadable = .init(initialValue: .notRequested)
        self.simulationsService = service
    }
    
    func getSimulations(completion: @escaping () -> Void, failure: @escaping (AppPopupSettings) -> Void) {
        self.completion = completion
        self.failure = failure
        switch simulationsLoadable {
        case .notRequested, .loaded(_), .failed(_):
            simulationsService
                .load(simulations: loadableSubject(\.simulationsLoadable))
            
        case .isLoading(_, _): break
        }
    }
    
    func deleteSimulations(completion: @escaping (AppPopupSettings) -> Void) {
        self.completionDelete = completion
        switch deleteSimulationAllLoadable {
        case .notRequested, .loaded(_), .failed(_):
            simulationsService
                .delete(simulations: loadableSubject(\.deleteSimulationAllLoadable))
            
        case .isLoading(_, _): break
        }
    }
    
    func deleteSimulation(indexSet: IndexSet, completion: @escaping (AppPopupSettings) -> Void) {
        self.completionDelete = completion
        self.deleteState.indexSet = indexSet
        if let index = self.deleteState.index, let simulationId = simulations[index].id {
            switch simulationsLoadable {
            case .notRequested, .loaded(_), .failed(_):
                simulationsService
                    .delete(id: simulationId, simulation: loadableSubject(\.deleteSimulationLoadable))
                
            case .isLoading(_, _): break
            }
        }
    }
    
    func build(state: Loadable<[INVSSimulatorModel]>) {
        switch state {
        case .notRequested:
            break
            
        case .isLoading(_, _):
            self.state = .loading
            
            break
        case .loaded(let response):
            self.simulations = response
            if self.simulations.count == 0 {
                message = "Nenhuma simulação foi encontrada, realize sua primeira simulação."
                self.failure?(AppPopupSettings(message: message, textColor: .white, backgroundColor: Color(.JEWDarkDefault()), position: .top, show: true))
            } else {
                self.completion?()
            }
            self.state = .loaded
        case .failed(let error):
            if let apiError = error as? APIError {
                self.message = apiError.errorDescription ?? String()
                self.failure?(AppPopupSettings(message: message, textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true))
            }
            self.state = .loaded
            break
        }
    }
    
    func buildDeleteAllSimulations(state: Loadable<DeleteSimulationModel>) {
        switch state {
        case .notRequested:
            break
            
        case .isLoading(_, _):
            self.state = .loading
            
            break
        case .loaded(let response):
            if response.deleted {
                self.simulations = [INVSSimulatorModel]()
                message = "Todas suas simulações foram apagadas com sucesso."
                self.completionDelete?(AppPopupSettings(message: message, textColor: .white, backgroundColor: Color(.JEWDarkDefault()), position: .top, show: true))
            } else {
                message = "Não foi possível apagar suas Simulações."
                self.completionDelete?(AppPopupSettings(message: message, textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true))
            }
            self.state = .loaded
        case .failed(let error):
            if let apiError = error as? APIError {
                self.message = apiError.errorDescription ?? String()
                self.completionDelete?(AppPopupSettings(message: message, textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true))
            }
            self.state = .loaded
            break
        }
    }
    
    func buildDeleteSimulation(state: Loadable<DeleteSimulationModel>) {
        switch state {
        case .notRequested:
            break
            
        case .isLoading(_, _):
            self.deleteState.isDeleting = true
            
            break
        case .loaded(let response):
            if response.deleted {
                if let indexSet = self.deleteState.indexSet {
                    self.simulations.remove(atOffsets: indexSet)
                }
                self.deleteState.indexSet = nil
                self.deleteState.isDeleting = false
                message = "Simulação apagada com sucesso."
                self.completionDelete?(AppPopupSettings(message: message, textColor: .white, backgroundColor: Color(.JEWDarkDefault()), position: .top, show: true))
            } else {
                message = "Não foi possível apagar a simulação."
                self.completionDelete?(AppPopupSettings(message: message, textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true))
            }
            self.state = .loaded
        case .failed(let error):
            if let apiError = error as? APIError {
                self.message = apiError.errorDescription ?? String()
                self.completionDelete?(AppPopupSettings(message: message, textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true))
            }
            self.state = .loaded
            break
        }
    }
}

class DeleteState {
    var index: Int? {
        self.indexSet?.first
    }
    var indexSet: IndexSet? = nil
    var isDeleting: Bool = false
}
