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
                .sinkToLoadable {_ in 
                   // simulations.wrappedValue = $0
            }
            .store(in: cancelBag)
    }
}

struct StubSimulationsService: SimulationsServiceProtocol {
    func load(simulations: LoadableSubject<[INVSSimulatorModel]>) {
        
    }
}
