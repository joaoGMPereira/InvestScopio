//
//  SimulationCell.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 16/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI

struct BlueButtonStyle: ButtonStyle {

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
        .font(.headline)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .contentShape(Rectangle())
        .foregroundColor(configuration.isPressed ? Color.white.opacity(0.5) : Color.white)
        .listRowBackground(configuration.isPressed ? Color.blue.opacity(0.5) : Color.blue)
  }
}


struct SimulationCell: View {
    var simulation: SimulatorModel
    @Binding var state: ViewState
    @Binding var cellSize: CGSize
    var selectable: Bool = false
    var action: () -> Void
    
    
    var body: some View {
        Button(action: action) {
            
            VStack(alignment: .leading, spacing: 16) {
                ForEach(simulation.generateDynamicContent()) { section in
                    SectionView(firstTitle: section.firstKey, firstValue: section.firstValue, secondTitle: section.secondKey, secondValue: section.secondValue, state: $state)
                }
            }
            .getContent(size: $cellSize)
            .padding()
            .background(Color("cellBackground"))
            .cornerRadius(8)
            .shadow(radius: 8)
            .padding([.top, .bottom], 8)
            .foregroundColor(Color(.label))
        }
        .allowsHitTesting(selectable)
        .buttonStyle(PlainButtonStyle())
    }
}


struct HeaderSimulationCell: View {
    @Binding var state: ViewState
    var simulation: SimulatorModel
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                SUIJewGenericView(viewState: state) {
                    Text("Valor Inicial:").font(.headline).minimumScaleFactor(0.5)
                }.cornerRadius(10)
                
                SUIJewGenericView(viewState: state) {
                    Text(self.simulation.initialValue.currencyFormat()).font(.callout).minimumScaleFactor(0.5)
                }.cornerRadius(10)
            }
            .lineLimit(1)
            Spacer()
        }
    }
}

struct BodySimulationCell: View {
    var simulation: SimulatorModel
    @Binding var state: ViewState
    var body: some View {
        VStack(spacing: 8) {
            SectionView(firstTitle: "Valor Mensal", firstValue: simulation.monthValue.currencyFormat(), secondTitle: "Taxa de Juros", secondValue: simulation.interestRate.currencyFormat().percentFormat(), state: $state)
            SectionView(firstTitle: "Total de Meses", firstValue: "\(simulation.totalMonths)", secondTitle: "Valor Inicial de Resgate", secondValue: simulation.initialMonthlyRescue.currencyFormat(), state: $state)
            SectionView(firstTitle: "Acréscimo no Resgate", firstValue: simulation.increaseRescue.currencyFormat(), secondTitle: "Próximo Objetivo", secondValue: simulation.goalIncreaseRescue.currencyFormat(), state: $state)
        }
    }
}


struct SectionView: View {
    var firstTitle: String?
    var firstValue: String?
    var secondTitle: String?
    var secondValue: String?
    @Binding var state: ViewState
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                SUIJewGenericView(viewState: state) {
                    Text(self.firstTitle ?? String()).font(.subheadline).bold()
                }.cornerRadius(10)
                SUIJewGenericView(viewState: state) {
                    Text(self.firstValue ?? String()).font(.callout)
                }.cornerRadius(10)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                SUIJewGenericView(viewState: state) {
                    Text(self.secondTitle ?? String()).font(.subheadline).bold()
                }.cornerRadius(10)
                SUIJewGenericView(viewState: state) {
                    Text(self.secondValue ?? String()).font(.callout)
                }.cornerRadius(10)
            }
        }
    }
}

struct SimulationCell_Previews: PreviewProvider {
    static var previews: some View {
        AppInitialization.initialize()
        return Group {
            SimulationCell(simulation: SimulatorModel.simulationsPlaceholders.first!, state: .constant(.loaded), cellSize: .constant(CGSize.init(width: 414, height: 200))){}.attachEnvironmentOverrides().previewDevice("iPhone Xs Max")
            SimulationCell(simulation: SimulatorModel.simulationsPlaceholders.first!, state: .constant(.loaded), cellSize: .constant(CGSize.init(width: 414, height: 200))){}.attachEnvironmentOverrides().previewDevice("iPad Pro (9.7-inch)")
        }
    }
}
