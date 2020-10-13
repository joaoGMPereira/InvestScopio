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

protocol SimulationDetailServiceProtocol {
    func load(simulationDetail: LoadableSubject<[INVSSimulatedValueModel]>, simulation: SimulatorModel)
}

struct SimulationDetailService: SimulationDetailServiceProtocol {
    
    let repository: SimulationDetailRepositoryProtocol
    
    init(repository: SimulationDetailRepositoryProtocol) {
        self.repository = repository
    }
    
    func load(simulationDetail: LoadableSubject<[INVSSimulatedValueModel]>, simulation: SimulatorModel) {
        let cancelBag = CancelBag()
        simulationDetail.wrappedValue = .isLoading(last: simulationDetail.wrappedValue.value, cancelBag: cancelBag)
            self.repository
                .simulationDetail(simulation: simulation)
                .sinkToLoadable { response in
                    guard let value = response.value else {
                        simulationDetail.wrappedValue = .failed(APIError.customError("Error"))
                        return
                    }
                    simulationDetail.wrappedValue = .loaded(value.data)
            }
            .store(in: cancelBag)
    }
}

struct StubSimulationDetailService: SimulationDetailServiceProtocol {
    func load(simulationDetail: LoadableSubject<[INVSSimulatedValueModel]>, simulation: SimulatorModel) {
        
    }
}
