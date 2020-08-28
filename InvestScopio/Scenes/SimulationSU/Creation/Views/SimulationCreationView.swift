//
//  SimulationCreationView.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 27/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI

struct SimulationCreationView: View {
    @ObservedObject var viewModel: SimulationCreationViewModel
    @State var textHeight: CGFloat = 44
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                AnimatedText(message: self.viewModel.step.setNextStep()) { size in
                    self.textHeight = size.height
                }
                DoubleButtons(firstIsLoading: .constant(false), secondIsLoading: .constant(false), firstModel: .init(title: "Limpar Histórico", color: Color("accent"), isFill: false), secondModel: .init(title: "Nova Simulação", color: Color("accent"), isFill: true), firstCompletion: {
                   //self.settings.popup = AppPopupSettings(message: "Atenção\nTODO LIMPAR HISTORICO", textColor: .black, backgroundColor: Color(.JEWLightDefault()), position: .top, show: true)
                    
                }) {
                   // self.settings.popup = AppPopupSettings(message: "Atenção\nTODO NOVA SIMULACAO", textColor: .black, backgroundColor: Color(.JEWLightDefault()), position: .top, show: true)
                }
                Spacer()
            }
        }
    }
}

struct SimulationCreationView_Previews: PreviewProvider {
    static var previews: some View {
        SimulationCreationView(viewModel: SimulationCreationViewModel())
    }
}
