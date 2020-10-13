//
//  SimulationDetailView.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 16/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI
import Charts
import JewFeatures

struct SimulationDetailView: View {
    
    @ObservedObject var viewModel: SimulationDetailViewModel
    @EnvironmentObject var reachability: Reachability
    @State var cellSize = CGSize.zero
    @State var showfirstSegment = false
    @State var chartSize = CGSize.zero
    
    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                if showfirstSegment {
                JewSegmentedControl(selectedIndex: $viewModel.typeIndex, rects: $viewModel.rectsType, titles: $viewModel.tabs, selectedColor: Color("accessoryBackgroundSelected"), unselectedColor: Color("accessoryBackground"), coordinateSpaceName: "TabsDetail").padding([.top, .horizontal], 8)
                }
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
                        VStack {
                            Text(viewModel.monthText()).font(Font.subheadline.bold()).multilineTextAlignment(.center).frame(maxWidth: .infinity)
                            Spacer()
                            Text(viewModel.valueText()).font(Font.subheadline.bold()).multilineTextAlignment(.center).frame(maxWidth: .infinity)
                        }.padding([.horizontal, .top])
                        LineChart(entries: viewModel.entries, months: viewModel.monthsValue ?? 0, hideHighlight: $viewModel.hideHighlight, indexSelected: $viewModel.indexSelected, positionXSelected: $viewModel.positionXSelected).frame(width: chartSize.width, height: 88)
                    }.getContent(size: $chartSize)
                }
            }
            .introspectViewController(customize: { (view) in
                view.background = .JEWBackground()
            })
        }.navigationBarTitle("Simulação", displayMode: .large)
            .onAppear {
                if !viewModel.isLoaded() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.showfirstSegment = true
                        self.viewModel.simulationDetail()
                    }
                }
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
        .shadow(radius: 8)
        .padding([.top, .bottom], 8)
    }
}

struct SimulationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SimulationDetailView(viewModel: SimulationDetailViewModel(service: SimulationDetailService(repository: SimulationDetailRepository())))
    }
}
