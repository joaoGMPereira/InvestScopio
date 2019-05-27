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
        var chartValues = [INVSChartModel]()
        
        for month in 0...totalMonths {
            let simulatedValue = simulatedValues[month]
            let valueWithoutRescue = (simulatedValue.total ?? 0) + (simulatedValue.rescue ?? 0)
            let chartModel = INVSChartModel(valueWithRescue: simulatedValue.total ?? 0, valueWithoutRescue: valueWithoutRescue, month: simulatedValue.month ?? 0)
            chartValues.append(chartModel)
        }

        let lastValueWithoutRescue = (simulatedValues[totalMonths].total ?? 0) + (simulatedValues[totalMonths].rescue ?? 0)
        let firstValue = simulatedValues.first?.total ?? 0
        presenter?.presentLeftAxys(withFirstTotal: firstValue, withLastTotal: lastValueWithoutRescue)
        presenter?.presentXAxys(withMonths: totalMonths)
        presenter?.presentCalculatedChartValues(withChartValues: chartValues, andMonths: totalMonths)
        
        
    }
    
}
