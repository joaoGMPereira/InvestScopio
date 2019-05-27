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
    func presentSegmentedControl(withMonths months: Int)
    func presentLeftAxys(withFirstTotal firstTotal: Double, withLastTotal lastTotal: Double)
    func presentXAxys(withMonths months: Int)
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
    
    func presentSegmentedControl(withMonths months: Int) {
        let totalMonths = "\(months) meses"
        let segmentValues = ["3 meses", "6 meses", "12 meses", totalMonths]
        controller?.displaySegmentedControl(withMonths: segmentValues)
    }
    
    
    func presentLeftAxys(withFirstTotal firstTotal: Double, withLastTotal lastTotal: Double) {
        controller?.displayLeftAxys(withFirstTotal: firstTotal, withLastTotal: lastTotal)
        
    }
    
    func presentXAxys(withMonths months: Int) {
        controller?.displayXAxys(withMonths: months)
    }
    
}
