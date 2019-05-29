//
//  INVSSimulatedChartsInteractor.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 26/05/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import Charts
protocol INVSSimulatedChartsInteractorProtocol {
    func setSegmentControl()
    func calculateChartValues(withMonths months: Int?)
}

class INVSSimulatedChartsInteractor: NSObject,INVSSimulatedChartsInteractorProtocol {
    
    var presenter: INVSSimulatedChartsPresenterProtocol?
    var simulatedValues = [INVSSimulatedValueModel]()
    var totalMonths: Int = 0
    
    func setSegmentControl() {
        presenter?.presentSegmentedControl(withMonths: simulatedValues.count - 1)
    }
    func calculateChartValues(withMonths months: Int?) {
        totalMonths = simulatedValues.count - 1
        if let months = months {
            totalMonths = months
        }
        presenter?.presentLeftAxys(withSimulatedValues: simulatedValues, andMonths: totalMonths)
        presenter?.presentXAxys(withMonths: totalMonths)
        presenter?.presentCalculatedChartValues(withSimulatedValues: simulatedValues, andMonths: totalMonths)
        
        
    }
    
}
