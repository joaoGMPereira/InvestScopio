//
//  INVSSimulatedChartsPresenter.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 26/05/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import Charts

protocol INVSSimulatedChartsPresenterProtocol {
     func presentCalculatedChartValues(withChartValues chartValues: [INVSChartModel], andMonths months: Int)
}

class INVSSimulatedChartsPresenter: NSObject,INVSSimulatedChartsPresenterProtocol {
    
    weak var controller: INVSSimulatedChartsViewControllerProtocol?

    func presentCalculatedChartValues(withChartValues chartValues: [INVSChartModel], andMonths months: Int) {
        var chartDataEntries = [ChartDataEntry]()
        for month in 0...months {
            let chartValueFiltered = chartValues.filter({$0.month == month}).first
            
            if let chartValue = chartValueFiltered {    
                if chartValue.valueWithoutRescue != chartValue.valueWithRescue {
                    chartDataEntries.append(ChartDataEntry(x: Double(month), y: chartValue.valueWithoutRescue))
                }
                chartDataEntries.append(ChartDataEntry(x: Double(month), y: chartValue.valueWithRescue))
                
            }
        }
        controller?.displayCalculatedChartValues(withChartDataEntries: chartDataEntries)
    }
    
}
