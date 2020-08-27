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
    func load(simulations: LoadableSubject<[INVSSimulatorModel]>)
}

struct SimulationsService: SimulationsServiceProtocol {
    
    let repository: SimulationsRepositoryProtocol
    
    init(repository: SimulationsRepositoryProtocol) {
        self.repository = repository
    }
    
    func load(simulations: LoadableSubject<[INVSSimulatorModel]>) {
        let cancelBag = CancelBag()
        simulations.wrappedValue = .isLoading(last: simulations.wrappedValue.value, cancelBag: cancelBag)
            self.repository
                .simulations()
                .sinkToLoadable { response in
                    guard let value = response.value else {
                        simulations.wrappedValue = .failed(APIError.customError("Error"))
                        return
                    }
                    simulations.wrappedValue = .loaded(value.data)
            }
            .store(in: cancelBag)
    }
}

struct StubSimulationsService: SimulationsServiceProtocol {
    func load(simulations: LoadableSubject<[INVSSimulatorModel]>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            simulations.wrappedValue = .loaded(INVSSimulatorModel.simulationsPlaceholders)
        }
    }
}


struct StubSimulationsServiceFailure: SimulationsServiceProtocol {
    func load(simulations: LoadableSubject<[INVSSimulatorModel]>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            simulations.wrappedValue = .failed(APIError.customError("Error"))
        }
    }
}

struct StubSimulationsServiceEmptySimulations: SimulationsServiceProtocol {
    func load(simulations: LoadableSubject<[INVSSimulatorModel]>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            simulations.wrappedValue = .loaded([INVSSimulatorModel]())
        }
    }
}
