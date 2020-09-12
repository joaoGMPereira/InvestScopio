//
//  SimulationsView.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 22/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI
import EnvironmentOverrides

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

struct SimulationsView: View {
    @EnvironmentObject var reachability: Reachability
    @EnvironmentObject var settings: AppSettings
    @ObservedObject var viewModel: SimulationsViewModel
    
    let detailViewModel = SimulationDetailViewModel(service: SimulationDetailService(repository: SimulationDetailRepository()))
    
    var foreverAnimation: Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                if viewModel.simulations.count == 0 {
                    ErrorView()
                } else {
                    LitSimulations(viewModel: viewModel, detailViewModel: detailViewModel)
                }
                DoubleButtons(firstIsLoading: .constant(false), secondIsLoading: .constant(false), firstModel: .init(title: "Nova Simulação", color: Color(.JEWDefault()), isFill: true), secondModel: .init(title: "Limpar Histórico", color: Color(.JEWDefault()), isFill: false), background: Color(.JEWBackground()), firstCompletion: {
                    self.settings.tabSelection = 1
                }) {
                    self.viewModel.deleteSimulations(completion: { settings in
                        self.settings.popup = settings
                    })
                }
            }
            .introspectViewController(customize: { (view) in
                view.background = .JEWBackground()
            })
            .navigationBarTitle("Simulações", displayMode: .large)
            .navigationBarItems(trailing:
                Button(action: {
                    self.viewModel.reload = true
                    DispatchQueue.main.async {
                        self.getSimulations()
                    }
                }, label: {
                    Image(systemName: SFSymbol.arrow2Circlepath.rawValue)
                        .rotationEffect(Angle(degrees: self.viewModel.reload ? 360.0 : 0.0))
                        .animation(viewModel.reload ? foreverAnimation : .default)
                })
            )
            .onAppear {
                DispatchQueue.main.async {
                    self.getSimulations()
                }
            }
        }
    }
    
    func getSimulations() {
        self.viewModel.getSimulations(completion: {
            self.viewModel.reload = false
            self.settings.popup = AppPopupSettings()
        }) { (settings) in
            self.viewModel.reload = false
            self.settings.popup = settings
        }
    }
}


struct ErrorView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Faça uma nova simulação a qualquer momento!")
                .font(.callout)
                .bold()
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing], 32)
            Text(";D")
                .font(.subheadline)
                .bold()
                .multilineTextAlignment(.center)
                .rotationEffect(.init(degrees: 90))
            Spacer()
        }
        .padding([.top], 32)
    }
}

struct LitSimulations: View {
    @EnvironmentObject var reachability: Reachability
    @ObservedObject var viewModel: SimulationsViewModel
    @ObservedObject var detailViewModel: SimulationDetailViewModel
    @State var cellSize = CGSize.zero
    @State private var selection: String? = nil
    var body: some View {
        List(viewModel.simulations) { simulation in
            NavigationLink(destination: NavigationLazyView(SimulationDetailView(viewModel: self.detailViewModel)), tag: simulation._id!, selection: self.$selection) {
                SimulationCell(simulation: simulation, state: self.$viewModel.state, cellSize: self.$cellSize, selectable: true) {
                    if self.reachability.isConnected {
                        self.detailViewModel.simulation = simulation
                        self.selection = simulation._id
                    }
                }
            }
        }
    }
}


struct SimulationsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkingAroundSUI.tableViewWorkingAround()
        return Group {
            SimulationsView(viewModel: SimulationsViewModel(service:StubSimulationsService())).attachEnvironmentOverrides().previewDevice("iPhone Xs Max")
            SimulationsView(viewModel: SimulationsViewModel(service:StubSimulationsServiceEmptySimulations())).attachEnvironmentOverrides().previewDevice("iPhone Xs Max")
            SimulationsView(viewModel: SimulationsViewModel(service:StubSimulationsServiceFailure())).attachEnvironmentOverrides().previewDevice("iPhone Xs Max")
            SimulationsView(viewModel: SimulationsViewModel(service:StubSimulationsService())).attachEnvironmentOverrides().previewDevice("iPad Pro (9.7-inch)")
        }
    }
}
