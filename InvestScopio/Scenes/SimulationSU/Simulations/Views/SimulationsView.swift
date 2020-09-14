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
                DoubleButtons(firstIsLoading: .constant(false), secondIsLoading: .constant(false), firstIsEnable: .constant(true), secondIsEnable: .constant(self.viewModel.simulations.count > 0), firstModel: .init(title: "Nova Simulação", color: Color(.JEWDefault()), isFill: true), secondModel: .init(title: "Limpar Histórico", color: Color(.JEWDefault()), isFill: false), background: Color(.JEWBackground()), firstCompletion: {
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
                    HStack {
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
                        EditButton()
                    }
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
    @EnvironmentObject var settings: AppSettings
    @ObservedObject var viewModel: SimulationsViewModel
    @ObservedObject var detailViewModel: SimulationDetailViewModel
    @State var cellSize = CGSize.zero
    @State private var selection: String? = nil
    var body: some View {
        let arrayIndexed = viewModel.simulations.enumerated().map({ $0 })
        return List {
            ForEach(arrayIndexed, id: \.element) { index, simulation in
                NavigationLink(destination: NavigationLazyView(SimulationDetailView(viewModel: self.detailViewModel)), tag: simulation._id ?? UUID().uuidString, selection: self.$selection) {
                    self.cell(simulation: simulation, index: index)
                }
            }.onDelete(perform: delete)
        }
    }
    
    func cell(simulation: INVSSimulatorModel, index: Int) -> some View {
        var isLoading = self.$viewModel.state
        if viewModel.deleteState.index == index && viewModel.deleteState.isDeleting {
            isLoading = .constant(.loading)
        }
        return SimulationCell(simulation: simulation, state: isLoading, cellSize: self.$cellSize, selectable: true) {
            if self.reachability.isConnected {
                self.detailViewModel.simulation = simulation
                self.selection = simulation._id
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        viewModel.deleteSimulation(indexSet: offsets) { (settings) in
            self.settings.popup = settings
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
