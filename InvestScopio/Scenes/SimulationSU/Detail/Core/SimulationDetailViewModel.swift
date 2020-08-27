//
//  SimulationDetailViewModel.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 16/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import SwiftUI
import Charts

enum ChartType: Int {
    case profitability
    case rescue
}

extension INVSSimulatedValueModel {
    static func placeholders() -> [INVSSimulatedValueModel] {
        return [INVSSimulatedValueModel.init(id: "testando", month: 1, monthValue: 3000, profitability: 3000, rescue: 1500, total: 101.500), INVSSimulatedValueModel.init(id: "testando2", month: 2, monthValue: 3000, profitability: 3000, rescue: 1500, total: 101.500), INVSSimulatedValueModel.init(id: "testando3", month: 3, monthValue: 3000, profitability: 3000, rescue: 1500, total: 101500), INVSSimulatedValueModel.init(id: "testando4", month: 4, monthValue: 3000, profitability: 3000, rescue: 1500, total: 101500)]
    }
}

class SimulationDetailViewModel: ObservableObject {
    
    @Published var simulation: INVSSimulatorModel {
        didSet {
            self.monthsTabs = setMonthsTabs(totalMonthUser: simulation.totalMonths)
        }
    }
    @Published var simulateds = INVSSimulatedValueModel.placeholders()
    @Published var monthsTabs: [String]
    @Published var typeIndex: Int = .zero {
        didSet {
            if typeIndex == 0 {
                valueIndex = .zero
                monthsIndex = .zero
            }
        }
    }
    @Published var valueIndex: Int = .zero
    @Published var monthsIndex: Int = .zero
    @Published var tabs = ["Lista","Grafico"]
    @Published var tabValues = ["Investido","Resgate"]
    @Published var simulationDetailLoadable: Loadable<[INVSSimulatedValueModel]> {
        didSet {
            build(state: simulationDetailLoadable)
        }
    }
    @Published var state: ViewState = .loaded
    @Published var showError = false
    @Published var showSuccess = false
    @Published var close = true
    @Published var messageError = String()
    @Published var messageSuccess = String()
    
    private var lastMonthIndex = 0
    
    var maxTotalValue: String {
        guard let monthsValue = monthsValue else {
            return simulateds.last?.total?.currencyFormat() ?? String()
        }
        let index = monthsValue - 1
        return simulateds[index].total?.currencyFormat() ?? String()
    }
    
    var maxTotalRescueValue: String {
        guard let monthsValue = monthsValue else {
            return simulateds.last?.totalRescue?.currencyFormat() ?? String()
        }
        let index = monthsValue - 1
        return simulateds[index].totalRescue?.currencyFormat() ?? String()
    }
    
    var chartType: ChartType {
        return ChartType(rawValue: valueIndex) ?? .profitability
    }
    
    var entries: [ChartDataEntry] {
        guard let monthsString = monthsTabs[monthsIndex].components(separatedBy: " ").first, let monthsValue = Int(monthsString) else {
            return [ChartDataEntry]()
        }
        shouldAnimate = lastMonthIndex != monthsIndex
        lastMonthIndex = monthsIndex
        return getEntries(months: monthsValue)
    }
    
    var shouldAnimate: Bool = true
    
    var monthsValue: Int? {
        guard let monthsString = monthsTabs[monthsIndex].components(separatedBy: " ").first, let monthsValue = Int(monthsString) else {
            return nil
        }
        return monthsValue
    }
    
    var granularity: Double {
        var granularity = 1.0
        if let months = monthsValue, months > 12 {
            granularity = 4
            if months > 50 {
                granularity = Double(months) * 0.1
            }
        }
        return granularity
    }
    
    var maximumValue: Double {
        guard let month = monthsValue, simulateds.indices.contains(month - 1) else {
            return 0
        }
        return chartType == .profitability ? simulateds[month - 1].total ?? 0 : simulateds[month - 1].totalRescue ?? 0
        
    }
    
    var description: String {
        chartType == .profitability ? "Total Investido" : "Total Resgatado"
    }
    
    let simulationDetailService: SimulationDetailServiceProtocol

    init(service: SimulationDetailServiceProtocol) {
        self._simulationDetailLoadable = .init(initialValue: .notRequested)
        self.simulationDetailService = service
        self.simulation = INVSSimulatorModel.simulationsPlaceholders.first!
        self.monthsTabs = ["3 meses", "6 meses", "12 meses"]
    }
    
    func simulationDetail() {
        clearTabs()
        switch simulationDetailLoadable {
        case .notRequested, .loaded(_), .failed(_):
            simulationDetailService
                .load(simulationDetail: loadableSubject(\.simulationDetailLoadable), simulation: simulation)
            
        case .isLoading(_, _): break
            //aguarde um momento
        }
    }
    
    private func getEntries(months: Int) -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        entries.append(ChartDataEntry(x: 0, y: chartType == .profitability ? simulation.initialValue: 0))
        for month in 0...months-1 {
            let simulatedValue = simulateds[month]
            entries.append(ChartDataEntry(x: Double(month+1), y: chartType == .profitability ? simulatedValue.total ?? 0 : simulatedValue.totalRescue ?? 0))
        }
        return entries
    }
    
    private func setMonthsTabs(totalMonthUser: Int) -> [String] {
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
    
    private func clearTabs() {
        typeIndex = .zero
        valueIndex = .zero
        monthsIndex = .zero
    }
    
    private func build(state: Loadable<[INVSSimulatedValueModel]>) {
        switch state {
        case .notRequested:
            break
            
        case .isLoading(_, _):
            self.showError = false
            self.state = .loading

            break
        case .loaded(let response):
            self.simulateds = response
            if simulateds.last?.totalRescue == 0 {
                tabValues = ["Investido"]
            } else {
                tabValues = ["Investido","Resgate"]
            }
            self.showError = false
            self.state = .loaded
        case .failed(let error):
            if let apiError = error as? APIError {
                self.messageError = apiError.errorDescription ?? String()
                self.showError = true
            }
            self.state = .loaded
            break
        }
    }
}
