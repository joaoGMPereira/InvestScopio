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
    func calculateChartValues()
}

class INVSSimulatedChartsInteractor: NSObject,INVSSimulatedChartsInteractorProtocol {
    
    var presenter: INVSSimulatedChartsPresenterProtocol?
    var simulatedValues = [INVSSimulatedValueModel]()
    func calculateChartValues() {
        var chartValues = [INVSChartModel]()
        for simulatedValue in simulatedValues {
            let valueWithoutRescue = (simulatedValue.total ?? 0) + (simulatedValue.rescue ?? 0)
            let chartModel = INVSChartModel(valueWithRescue: simulatedValue.total ?? 0, valueWithoutRescue: valueWithoutRescue, month: simulatedValue.month ?? 0)
            chartValues.append(chartModel)
        }
        presenter?.presentCalculatedChartValues(withChartValues: chartValues, andMonths: simulatedValues.count)
        
    }
    
}
