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
    func presentCalculatedChartValues(withSimulatedValues simulatedValues: [INVSSimulatedValueModel], andMonths months: Int)
    func presentSegmentedControl(withMonths months: Int)
    func presentLeftAxys(withSimulatedValues simulatedValues: [INVSSimulatedValueModel], andMonths months: Int)
    func presentXAxys(withMonths months: Int)
}

class INVSSimulatedChartsPresenter: NSObject,INVSSimulatedChartsPresenterProtocol {
    
    weak var controller: INVSSimulatedChartsViewControllerProtocol?

    func presentCalculatedChartValues(withSimulatedValues simulatedValues: [INVSSimulatedValueModel], andMonths months: Int) {
        var totalChartDataEntries = [ChartDataEntry]()
        var rescueChartDataEntries = [ChartDataEntry]()
        for month in 0...months {
            let simulatedValue = simulatedValues[month]
            totalChartDataEntries.append(ChartDataEntry(x: Double(month), y: simulatedValue.total ?? 0))
            rescueChartDataEntries.append(ChartDataEntry(x: Double(month), y: simulatedValue.rescue ?? 0))
        }
        controller?.displayTotalCalculatedChartValues(withTotalChartDataEntries: totalChartDataEntries)
        controller?.displayRescueCalculatedChartValues(withRescueChartDataEntries: rescueChartDataEntries)
    }
    
    func presentSegmentedControl(withMonths months: Int) {
        var segmentValues = [String]()
        segmentValues = setSegmentValues(totalMonthUser: months)
        controller?.displayTotalSegmentedControl(withMonths: segmentValues)
    }
    
    func setSegmentValues(totalMonthUser: Int) -> [String] {
        let totalMonths = "\(totalMonthUser) meses"
        var segmentValues = [String]()
        if totalMonthUser > 12 {
            segmentValues = ["3 meses", "6 meses", "12 meses", totalMonths]
        } else {
            if totalMonthUser == 12 {
                segmentValues = ["1 mês","3 meses", "6 meses", "12 meses"]
            } else {
                var monthsDefault = [1]
                if totalMonthUser > 2 {
                    monthsDefault = [1,2]
                }
                if totalMonthUser > 3 {
                    monthsDefault = [1,2,3]
                }
                if totalMonthUser > 6 {
                    monthsDefault = [1,3,6]
                }
                monthsDefault.append(totalMonthUser)
                monthsDefault = Array(Set(monthsDefault))
                monthsDefault = monthsDefault.sorted()
                for month in monthsDefault {
                    if month == 1 {
                        segmentValues.append("\(month) mês")
                    } else {
                        segmentValues.append("\(month) meses")
                    }
                }
            }
        }
        return segmentValues
    }
    
    
    func presentLeftAxys(withSimulatedValues simulatedValues: [INVSSimulatedValueModel], andMonths months: Int) {
        let lastTotal = (simulatedValues[months].total ?? 0)
        let lastRescue = (simulatedValues[months].rescue ?? 0)
        controller?.displayTotalLeftAxys(withLastTotal: lastTotal)
        controller?.displayRescueLeftAxys(withLastRescue: lastRescue)
    }
    
    func presentXAxys(withMonths months: Int) {
       var granularity = 1.0
        if months > 12 {
            granularity = 4
            if months > 50 {
                granularity = Double(months) * 0.1
            }
        }
        controller?.displayTotalXAxys(withMonths: months, andGranularity: granularity)
        controller?.displayRescueXAxys(withMonths: months, andGranularity: granularity)
    }
    
}
