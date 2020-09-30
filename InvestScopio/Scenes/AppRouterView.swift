//
//  LoginRouterView.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 16/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI
import JewFeatures
import Introspect

class AppRouterState {
    var loginViewModel = LoginViewModel(service: LoginService(webRepository: LoginWebRepository()))
    var registerViewModel = RegisterViewModel(service: RegisterService(repository: RegisterRepository()))
    var resendPasswordViewModel = ResendPasswordViewModel(service: ResendPasswordService())
    var simulationsViewModel = SimulationsViewModel(service: SimulationsService(repository: SimulationsRepository()))
    var simulationCreationStepViewModel = SimulationCreationStepViewModel()
    var simulationCreationViewModel = SimulationCreationViewModel(allSteps: StepModel.allDefaultSteps)
    var simulationCreationDetailViewModel = SimulationDetailViewModel(service: SimulationDetailService(repository: SimulationDetailRepository()))
    var startViewModel = StartViewModel(service: StartService(webRepository: LoginWebRepository()))
    var talkWithUsViewModel = TalkWithUsViewModel(service: TalkWithUsService(repository: TalkWithUsRepository()))
    
    func cleanLoggedScenes() {
        simulationsViewModel = SimulationsViewModel(service: SimulationsService(repository: SimulationsRepository()))
        simulationCreationStepViewModel = SimulationCreationStepViewModel()
        simulationCreationViewModel = SimulationCreationViewModel(allSteps: StepModel.allDefaultSteps)
        simulationCreationDetailViewModel = SimulationDetailViewModel(service: SimulationDetailService(repository: SimulationDetailRepository()))
        startViewModel = StartViewModel(service: StartService(webRepository: LoginWebRepository()))
        talkWithUsViewModel = TalkWithUsViewModel(service: TalkWithUsService(repository: TalkWithUsRepository()))
    }
}

struct AppRouterView: View {
    @EnvironmentObject var settings: AppSettings
    let state = AppRouterState()
    var body: some View {
        ZStack {
            switch settings.loggingState {
            case .normal:
                normalLogging
            case .admin:
                adminLogging
            case .notLogged:
                notLogged
            }
            
            PopupView(text: self.$settings.popup.message, textColor: self.$settings.popup.textColor, backgroundColor: self.$settings.popup.backgroundColor, position: self.$settings.popup.position, show: self.$settings.popup.show, checkReachability: .constant(true))
        }.onAppear {
            settings.didLogout = {
                state.cleanLoggedScenes()
            }
        }
    }
    
    var normalLogging: some View {
        TabView(selection: $settings.tabSelection) {
            SimulationsView(viewModel: state.simulationsViewModel)
                .tag(0)
                .tabItem {
                    Image(systemName: SFSymbol.listBullet.rawValue)
                    Text("Simulações")
                }.navigationViewStyle(StackNavigationViewStyle())
            SimulationCreationView(viewModel: state.simulationCreationViewModel, detailViewModel: state.simulationCreationDetailViewModel, stepViewModel: state.simulationCreationStepViewModel)
                .tag(1)
                .tabItem {
                    Image(systemName: SFSymbol.chartBarFill.rawValue)
                    Text("Simulação")
                }.navigationViewStyle(StackNavigationViewStyle())
            TalkWithUsView(viewModel: state.talkWithUsViewModel)
                .tag(2)
                .tabItem {
                    Image(systemName: SFSymbol.personFill.rawValue)
                    Text("Fale conosco")
                }.navigationViewStyle(StackNavigationViewStyle())
        }
        .accentColor(Color(.JEWDefault()))
        .attachEnvironmentOverrides()
    }
    
    var adminLogging: some View {
        TabView(selection: $settings.tabSelection) {
            SimulationCreationView(viewModel: state.simulationCreationViewModel, detailViewModel: state.simulationCreationDetailViewModel, stepViewModel: state.simulationCreationStepViewModel)
                .tag(1)
                .tabItem {
                    Image(systemName: SFSymbol.chartBarFill.rawValue)
                    Text("Simulação")
                }.navigationViewStyle(StackNavigationViewStyle())
            TalkWithUsView(viewModel: state.talkWithUsViewModel)
                .tag(2)
                .tabItem {
                    Image(systemName: SFSymbol.personFill.rawValue)
                    Text("Fale conosco")
                }.navigationViewStyle(StackNavigationViewStyle())
        }
        .accentColor(Color(.JEWDefault()))
        .attachEnvironmentOverrides()
    }
    
    var notLogged: some View {
        Group {
            if settings.checkUser {
                StartView(viewModel: state.startViewModel)
                
            } else {
                LoginView(viewModel: state.loginViewModel, registerViewModel: state.registerViewModel, resendPasswordViewModel: state.resendPasswordViewModel)
                    .attachEnvironmentOverrides()
            }
        }
    }
}

struct LoginRouterView_Previews: PreviewProvider {
    static var previews: some View {
        AppRouterView().environmentObject(AppSettings())
    }
}
