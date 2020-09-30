//
//  RegisterService.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 20/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import JewFeatures
import Combine
import FirebaseAuth
import Foundation
import SwiftUI

protocol SimulationsServiceProtocol {
    func load(simulations: LoadableSubject<[SimulatorModel]>)
    func delete(simulations: LoadableSubject<DeleteSimulationModel>)
    func delete(id: String, simulation: LoadableSubject<DeleteSimulationModel>)
}

struct SimulationsService: SimulationsServiceProtocol {
    
    let repository: SimulationsRepositoryProtocol
    
    init(repository: SimulationsRepositoryProtocol) {
        self.repository = repository
    }
    
    func load(simulations: LoadableSubject<[SimulatorModel]>) {
        let cancelBag = CancelBag()
        simulations.wrappedValue = .isLoading(last: simulations.wrappedValue.value, cancelBag: cancelBag)
            self.repository
                .simulations()
                .sinkToLoadable { response in
                    guard let value = response.value else {
                        simulations.wrappedValue = .failed(APIError.default)
                        return
                    }
                    simulations.wrappedValue = .loaded(value.data)
            }
            .store(in: cancelBag)
    }
    
    func delete(simulations: LoadableSubject<DeleteSimulationModel>) {
        let cancelBag = CancelBag()
        simulations.wrappedValue = .isLoading(last: simulations.wrappedValue.value, cancelBag: cancelBag)
            self.repository
                .deleteSimulations()
                .sinkToLoadable { response in
                    guard let value = response.value else {
                        simulations.wrappedValue = .failed(APIError.default)
                        return
                    }
                    simulations.wrappedValue = .loaded(value.data)
            }
            .store(in: cancelBag)
    }
    
    func delete(id: String, simulation: LoadableSubject<DeleteSimulationModel>) {
        let cancelBag = CancelBag()
        simulation.wrappedValue = .isLoading(last: simulation.wrappedValue.value, cancelBag: cancelBag)
            self.repository
                .deleteSimulation(id: id)
                .sinkToLoadable { response in
                    guard let value = response.value else {
                        simulation.wrappedValue = .failed(APIError.default)
                        return
                    }
                    simulation.wrappedValue = .loaded(value.data)
            }
            .store(in: cancelBag)
    }
}

struct StubSimulationsService: SimulationsServiceProtocol {
    func delete(id: String, simulation: LoadableSubject<DeleteSimulationModel>) {
        
    }
    
    func delete(simulations: LoadableSubject<DeleteSimulationModel>) {
        
    }
    
    func load(simulations: LoadableSubject<[SimulatorModel]>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            simulations.wrappedValue = .loaded(SimulatorModel.simulationsPlaceholders)
        }
    }
}


struct StubSimulationsServiceFailure: SimulationsServiceProtocol {
    func delete(id: String, simulation: LoadableSubject<DeleteSimulationModel>) {
        
    }
    
    func delete(simulations: LoadableSubject<DeleteSimulationModel>) {
        
    }
    
    func load(simulations: LoadableSubject<[SimulatorModel]>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            simulations.wrappedValue = .failed(APIError.customError("Error"))
        }
    }
}

struct StubSimulationsServiceEmptySimulations: SimulationsServiceProtocol {
    func delete(id: String, simulation: LoadableSubject<DeleteSimulationModel>) {
        
    }
    
    func delete(simulations: LoadableSubject<DeleteSimulationModel>) {
        
    }
    
    func load(simulations: LoadableSubject<[SimulatorModel]>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            simulations.wrappedValue = .loaded([SimulatorModel]())
        }
    }
}
