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
    @Published var deleteSimulationLoadable: Loadable<DeleteSimulationModel> {
        didSet {
            buildDelete(state: deleteSimulationLoadable)
        }
    }
    @Published var state: ViewState = .loading
    @Published var reload = false
    @Published var messageError = String()
    @Published var messageSuccess = String()
    
    let simulationsService: SimulationsServiceProtocol
    var completion: (() -> Void)?
    var completionDeleteAll: ((AppPopupSettings) -> Void)?
    var failure:((AppPopupSettings) -> Void)?

    init(service: SimulationsServiceProtocol) {
        self._simulationsLoadable = .init(initialValue: .notRequested)
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
        self.completionDeleteAll = completion
        switch simulationsLoadable {
        case .notRequested, .loaded(_), .failed(_):
            simulationsService
                .delete(simulations: loadableSubject(\.deleteSimulationLoadable))
            
        case .isLoading(_, _): break
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
                messageError = "Atenção!\nNenhuma simulação foi encontrada, realize sua primeira simulação."
                self.failure?(AppPopupSettings(message: messageError, textColor: .white, backgroundColor: Color(.JEWDarkDefault()), position: .top, show: true))
            } else {
                self.completion?()
            }
            self.state = .loaded
        case .failed(let error):
            if let apiError = error as? APIError {
                self.messageError = apiError.errorDescription ?? String()
                self.failure?(AppPopupSettings(message: messageError, textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true))
            }
            self.state = .loaded
            break
        }
    }
    
    func buildDelete(state: Loadable<DeleteSimulationModel>) {
        switch state {
        case .notRequested:
            break
            
        case .isLoading(_, _):
            self.state = .loading

            break
        case .loaded(let response):
            if response.deleted {
            self.simulations = [INVSSimulatorModel]()
                messageError = "Atenção!\nTodas suas simulações foram apagadas com sucesso."
                self.completionDeleteAll?(AppPopupSettings(message: messageError, textColor: .white, backgroundColor: Color(.JEWDarkDefault()), position: .top, show: true))
            } else {
                messageError = "Atenção!\nNão foi possível apagar suas Simulações."
                self.completionDeleteAll?(AppPopupSettings(message: messageError, textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true))
            }
            self.state = .loaded
        case .failed(let error):
            if let apiError = error as? APIError {
                self.messageError = apiError.errorDescription ?? String()
                self.completionDeleteAll?(AppPopupSettings(message: messageError, textColor: .white, backgroundColor: Color(.JEWRed()), position: .top, show: true))
            }
            self.state = .loaded
            break
        }
    }
}
