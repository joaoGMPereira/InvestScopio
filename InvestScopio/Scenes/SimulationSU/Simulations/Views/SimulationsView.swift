//
//  SimulationsView.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 22/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI
import EnvironmentOverrides
import SwiftUICharts
import QGrid

struct SimulationsView: View {
    @State var simulations = INVSSimulatorModel.simulationsTeste
    @ObservedObject var viewModel: SimulationsViewModel
    @State var cellSize = CGSize.zero
    var body: some View {
        ZStack {
            Color.init(.systemGroupedBackground).edgesIgnoringSafeArea(.all)
            List(simulations) { simulation in
                Section {
                    SimulationCell(simulation: simulation, cellSize: self.$cellSize)
                }
            }
        }.onAppear {
            self.viewModel.getSimulations()
        }
    }
}

struct SimulationCell: View {
    var simulation: INVSSimulatorModel
    @State var showChart = false
    @Binding var cellSize: CGSize
    var chartStyle = ChartStyle(
        backgroundColor: Color.clear,
        accentColor: Color(UIColor.JEWDefault()),
        secondGradientColor: Color(UIColor.JEWLightDefault()),
        textColor: Color("textColor"),
        legendTextColor: Color.gray,
        dropShadowColor: Color.gray)
    
    
    func getChartStyle() -> ChartStyle {
        chartStyle.darkModeStyle = chartStyle
        return chartStyle
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HeaderSimulationCell(showChart: $showChart)
            if UIDevice.current.userInterfaceIdiom == .pad {
                HStack {
                    contentView(showChart: $showChart)
                }
            } else {
                contentView(showChart: $showChart)
            }
        }
        .getContent(size: $cellSize)
        .padding()
        .background(Color.init(.tertiarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous), style: .init())
        .shadow(color: Color.primary.opacity(0.3), radius: 8, x: 1, y: 1)
        .padding()
    }
    
    func contentView(showChart: Binding<Bool>) -> some View {
        Group {
            BodySimulationCell()
            if self.showChart {
                BarChartView(data: ChartData(values: [("01/2020",3000), ("02/2020",3100), ("03/2020",3200), ("04/2020",3500)]), title: "Valor Atual: R$ 3,500.00", style: self.getChartStyle(), form: .init(width: UIDevice.current.userInterfaceIdiom == .pad ? 200 : cellSize.width, height: 300), dropShadow: false, valueSpecifier: "R$ %.2f")
            }
        }
    }
}


struct HeaderSimulationCell: View {
    @Binding var showChart: Bool
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Valor Inicial:").font(.headline).minimumScaleFactor(0.5)
                Text("R$ 5.000.000.000,00").font(.callout).minimumScaleFactor(0.5)
            }
            .lineLimit(1)
            Spacer()
            Image(symbol: .arrowDown).rotationEffect(Angle.init(degrees: self.showChart ? 180 : 0)).frame(width: 36, height: 36).onTapGesture {
                withAnimation(.easeInOut) {
                    self.showChart.toggle()
                }
            }
        }
    }
}

struct BodySimulationCell: View {
    var body: some View {
        VStack(spacing: 8) {
            SectionView(firstTitle: "Valor Mensal", firstValue: "R$ 500,00", secondTitle: "Taxa de Juros", secondValue: "3,00%")
            SectionView(firstTitle: "Total de Meses", firstValue: "60", secondTitle: "Valor Inicial de Resgate", secondValue: "R$ 300,00")
            SectionView(firstTitle: "Acréscimo no Resgate", firstValue: "R$ 200,00", secondTitle: "Próximo Objetivo", secondValue: "3,00%")
        }
    }
}


struct SectionView: View {
    var firstTitle: String
    var firstValue: String
    var secondTitle: String
    var secondValue: String
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(firstTitle).font(.headline).minimumScaleFactor(0.3)
                    .lineLimit(1)
                Text(firstValue).font(.callout).minimumScaleFactor(0.3)
                    .lineLimit(1)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(secondTitle).font(.headline).minimumScaleFactor(0.3)
                    .lineLimit(1)
                Text(secondValue).font(.callout).minimumScaleFactor(0.3)
                    .lineLimit(1)
            }
        }
    }
}

struct SimulationsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SimulationsView(viewModel: SimulationsViewModel(service: SimulationsService(repository: SimulationsRepository()))).attachEnvironmentOverrides().previewDevice("iPhone Xs Max")
            SimulationsView(viewModel: SimulationsViewModel(service: SimulationsService(repository: SimulationsRepository()))).attachEnvironmentOverrides().previewDevice("iPad Pro (9.7-inch)")
        }
    }
}

extension INVSSimulatorModel {
    static let simulationsTeste = [INVSSimulatorModel.init(initialValue: 30000, monthValue: 500, interestRate: 3, totalMonths: 30, initialMonthlyRescue: 20, increaseRescue: 50, goalIncreaseRescue: 300, isSimply: false, id: 1312313188882312), INVSSimulatorModel.init(initialValue: 30000, monthValue: 500, interestRate: 3, totalMonths: 30, initialMonthlyRescue: 20, increaseRescue: 50, goalIncreaseRescue: 300, isSimply: false, id: 1319999923131212), INVSSimulatorModel.init(initialValue: 30000, monthValue: 500, interestRate: 3, totalMonths: 30, initialMonthlyRescue: 20, increaseRescue: 50, goalIncreaseRescue: 300, isSimply: false, id: 131929212312), INVSSimulatorModel.init(initialValue: 30000, monthValue: 500, interestRate: 3, totalMonths: 30, initialMonthlyRescue: 20, increaseRescue: 50, goalIncreaseRescue: 300, isSimply: false, id: 13191919123), INVSSimulatorModel.init(initialValue: 30000, monthValue: 500, interestRate: 3, totalMonths: 30, initialMonthlyRescue: 20, increaseRescue: 50, goalIncreaseRescue: 300, isSimply: false, id: 13891112312312), INVSSimulatorModel.init(initialValue: 30000, monthValue: 500, interestRate: 3, totalMonths: 30, initialMonthlyRescue: 20, increaseRescue: 50, goalIncreaseRescue: 300, isSimply: false, id: 8912371293), INVSSimulatorModel.init(initialValue: 30000, monthValue: 500, interestRate: 3, totalMonths: 30, initialMonthlyRescue: 20, increaseRescue: 50, goalIncreaseRescue: 300, isSimply: false, id: 91829228), INVSSimulatorModel.init(initialValue: 30000, monthValue: 500, interestRate: 3, totalMonths: 30, initialMonthlyRescue: 20, increaseRescue: 50, goalIncreaseRescue: 300, isSimply: false, id: 47827319), INVSSimulatorModel.init(initialValue: 30000, monthValue: 500, interestRate: 3, totalMonths: 30, initialMonthlyRescue: 20, increaseRescue: 50, goalIncreaseRescue: 300, isSimply: false, id: 138129312), INVSSimulatorModel.init(initialValue: 30000, monthValue: 500, interestRate: 3, totalMonths: 30, initialMonthlyRescue: 20, increaseRescue: 50, goalIncreaseRescue: 300, isSimply: false, id: 19831299), INVSSimulatorModel.init(initialValue: 30000, monthValue: 500, interestRate: 3, totalMonths: 30, initialMonthlyRescue: 20, increaseRescue: 50, goalIncreaseRescue: 300, isSimply: false, id: 2938129), INVSSimulatorModel.init(initialValue: 30000, monthValue: 500, interestRate: 3, totalMonths: 30, initialMonthlyRescue: 20, increaseRescue: 50, goalIncreaseRescue: 300, isSimply: false, id: 71823711), INVSSimulatorModel.init(initialValue: 30000, monthValue: 500, interestRate: 3, totalMonths: 30, initialMonthlyRescue: 20, increaseRescue: 50, goalIncreaseRescue: 300, isSimply: false, id: 1129381239)]
}
