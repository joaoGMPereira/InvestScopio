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
    
    @State var chartSize = CGSize.zero
   
    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                
                JewSegmentedControl(selectedIndex: $viewModel.typeIndex, rects: $viewModel.rectsType, titles: $viewModel.tabs, selectedColor: Color("accessoryBackgroundSelected"), unselectedColor: Color("accessoryBackground"), coordinateSpaceName: "TabsDetail").padding([.top, .horizontal], 8)
                if viewModel.typeIndex == 0 {
                    List {
                        SimulationCell(simulation: viewModel.simulation, state: self.$viewModel.state, cellSize: self.$cellSize){}
                        ForEach(self.viewModel.simulateds, id: \.id) { simulated in
                            SimulatedCell(simulated: simulated, cellSize: self.$cellSize, state: self.$viewModel.state)
                        }
                    }.id(UUID())
                }
                if viewModel.typeIndex == 1 {
                    ScrollView {
                    JewSegmentedControl(selectedIndex: $viewModel.valueIndex, rects: $viewModel.rectsValue, titles: $viewModel.tabValues, selectedColor: Color("accessoryBackgroundSelected"), unselectedColor: Color("accessoryBackground"), coordinateSpaceName: "TabsValues").padding(.horizontal, 16)
                    
                    JewSegmentedControl(selectedIndex: $viewModel.monthsIndex, rects: $viewModel.rectsMonths, titles: $viewModel.monthsTabs, selectedColor: Color("accessoryBackgroundSelected"), unselectedColor: Color("accessoryBackground"), coordinateSpaceName: "TabsMonths").padding(.horizontal, 24)
                    
                        LineChart(entries: viewModel.entries, months: viewModel.monthsValue ?? 0, granularity: viewModel.granularity, axisMaximum: viewModel.maximumValue, label: viewModel.description).setChartDataBase(ChartDataBaseBridge(informationData: ChartInformationDataBridge(leftAxis: LeftAxisBridge(formatter: leftAxisFormatter), xAxis: XAxisBridge(formatter: xAxisFormatter)))).setChartDataSet(LineChartDataSetBaseBridge(xAxisDuration: viewModel.shouldAnimate ? 0.0 : 0, yAxisDuration: viewModel.shouldAnimate ? 0.5 : 0)).frame(width: chartSize.width, height: chartSize.width)
                    }.getContent(size: $chartSize)
                }
            }
            .introspectViewController(customize: { (view) in
                view.background = .JEWBackground()
            })
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
        .background(Color("cellBackground"))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous), style: .init())
        .shadow(color: Color("accessoryBackground").opacity(0.8), radius: 8)
        .padding([.top, .bottom], 8)
    }
}

struct SimulationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SimulationDetailView(viewModel: SimulationDetailViewModel(service: SimulationDetailService(repository: SimulationDetailRepository())))
    }
}
