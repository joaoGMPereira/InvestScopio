//
//  SimulationDetailView.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 16/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI
import Charts

struct SimulationDetailView: View {
    
    var leftAxisFormatter: NumberFormatter {
        let formatter = NumberFormatter.currencyDefault()
        formatter.negativePrefix = "R$ "
        formatter.positivePrefix = "R$ "
        return formatter
    }
    
    var xAxisFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = false
        return formatter
    }
    
    @ObservedObject var viewModel: SimulationDetailViewModel
    @EnvironmentObject var reachability: Reachability
    @State var cellSize = CGSize.zero
   
    var body: some View {
        ZStack {
            VStack(spacing: 4) {
                Picker("TabsDetail", selection: $viewModel.typeIndex) {
                    ForEach(0 ..< viewModel.tabs.count) { index in
                        Text(self.viewModel.tabs[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 8)
                if viewModel.typeIndex == 1 {
                    Picker("TabsValues", selection: $viewModel.valueIndex) {
                        ForEach(0 ..< viewModel.tabValues.count) { index in
                            Text(self.viewModel.tabValues[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 16)
                    Picker("TabsMonths", selection: $viewModel.monthsIndex) {
                        ForEach(0 ..< viewModel.monthsTabs.count) { index in
                            Text(self.viewModel.monthsTabs[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 24)
                }
                if viewModel.typeIndex == 0 {
                    List {
                        SimulationCell(simulation: viewModel.simulation, state: self.$viewModel.state, cellSize: self.$cellSize){}
                        ForEach(self.viewModel.simulateds, id: \.id) { simulated in
                            SimulatedCell(simulated: simulated, cellSize: self.$cellSize, state: self.$viewModel.state)
                        }
                    }.transition(AnyTransition.move(edge: .leading))
                }
                if viewModel.typeIndex == 1 {
                    LineChart(entries: viewModel.entries, months: viewModel.monthsValue ?? 0, granularity: viewModel.granularity, axisMaximum: viewModel.maximumValue, label: viewModel.description).setChartDataBase(ChartDataBaseBridge(informationData: ChartInformationDataBridge(leftAxis: LeftAxisBridge(formatter: leftAxisFormatter), xAxis: XAxisBridge(formatter: xAxisFormatter)))).setChartDataSet(LineChartDataSetBaseBridge(xAxisDuration: viewModel.shouldAnimate ? 0.0 : 0, yAxisDuration: viewModel.shouldAnimate ? 0.5 : 0))
                }
            }
        }.navigationBarTitle("Simulação", displayMode: .large)
        .onAppear {
            self.viewModel.simulationDetail()
        }.animation(.easeInOut)
    }
}


struct SimulatedCell: View {
    var simulated: INVSSimulatedValueModel
    @Binding var cellSize: CGSize
    @Binding var state: ViewState
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionView(firstTitle: "Período/Mês", firstValue: "\(simulated.month ?? 0)", secondTitle: "Rentabilidade", secondValue: simulated.profitability?.currencyFormat(), state: $state)
            SectionView(firstTitle: "Resgate", firstValue: simulated.rescue?.currencyFormat(), secondTitle: "Total", secondValue: simulated.total?.currencyFormat(), state: $state)
        }
        .getContent(size: $cellSize)
        .padding()
        .background(Color("background3"))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous), style: .init())
        .shadow(color: Color.primary.opacity(0.3), radius: 8, x: 0.5, y: 0.5)
        .padding([.top, .bottom], 8)
    }
}

struct SimulationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SimulationDetailView(viewModel: SimulationDetailViewModel(service: SimulationDetailService(repository: SimulationDetailRepository())))
    }
}
