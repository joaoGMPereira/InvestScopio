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
                DoubleButtons(firstIsLoading: .constant(false), secondIsLoading: .constant(false), firstIsEnable: .constant(true), secondIsEnable: .constant(viewModel.simulations.count > 0), firstModel: .init(title: "Nova Simulação", color: Color(.JEWDefault()), isFill: true), secondModel: .init(title: "Limpar Histórico", color: Color(.JEWDefault()), isFill: false), background: Color(.JEWBackground()), firstCompletion: {
                    settings.tabSelection = 1
                }) {
                    viewModel.deleteSimulations(completion: { settings in
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
                                            viewModel.reload = true
                                            DispatchQueue.main.async {
                                                getSimulations()
                                            }
                                        }, label: {
                                            Image(systemName: SFSymbol.arrow2Circlepath.rawValue)
                                                .rotationEffect(Angle(degrees: viewModel.reload ? 360.0 : 0.0))
                                                .animation(viewModel.reload ? foreverAnimation : .default)
                                        })
                                        EditButton()
                                    }
            )
            .onAppear {
                DispatchQueue.main.async {
                    guard #available(iOS 14.0, *) else {
                        getSimulations()
                        return
                    }
                    self.settings.tabSelected = { tab in
                        if tab == 0 {
                            getSimulations()
                        }
                    }
                    
                }
            }
        }
    }
    
    func getSimulations() {
        viewModel.getSimulations(completion: {
            viewModel.reload = false
            settings.popup = AppPopupSettings()
        }) { (settings) in
            viewModel.reload = false
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
                    cell(simulation: simulation, index: index)
                        .background(NavigationLink(destination: NavigationLazyView(SimulationDetailView(viewModel: detailViewModel)), tag: simulation._id ?? UUID().uuidString, selection: $selection) {EmptyView()})
                        .padding(.horizontal)
                        .listRowInsets(EdgeInsets())
                        
            }.onDelete(perform: delete).background(Color(.JEWBackground()))
        }
    }
    
    func cell(simulation: INVSSimulatorModel, index: Int) -> some View {
        var isLoading = $viewModel.state
        if viewModel.deleteState.index == index && viewModel.deleteState.isDeleting {
            isLoading = .constant(.loading)
        }
        return SimulationCell(simulation: simulation, state: isLoading, cellSize: $cellSize, selectable: true) {
            if reachability.isConnected {
                detailViewModel.simulation = simulation
                selection = simulation._id
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
