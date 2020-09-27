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

struct AppRouterView: View {
    @EnvironmentObject var settings: AppSettings
    let loginViewModel = LoginViewModel(service: LoginService(webRepository: LoginWebRepository()))
    let registerViewModel = RegisterViewModel(service: RegisterService(repository: RegisterRepository()))
    let resendPasswordViewModel = ResendPasswordViewModel(service: ResendPasswordService())
    let simulationsViewModel = SimulationsViewModel(service: SimulationsService(repository: SimulationsRepository()))
    let simulationCreationStepViewModel = SimulationCreationStepViewModel()
    let simulationCreationViewModel = SimulationCreationViewModel(allSteps: StepModel.allDefaultSteps)
    let simulationCreationDetailViewModel = SimulationDetailViewModel(service: SimulationDetailService(repository: SimulationDetailRepository()))
    let startViewModel = StartViewModel(service: StartService(webRepository: LoginWebRepository()))
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
        }
    }
    
    var normalLogging: some View {
        TabView(selection: $settings.tabSelection) {
            SimulationsView(viewModel: simulationsViewModel)
                .tag(0)
                .tabItem {
                    Image(systemName: SFSymbol.listBullet.rawValue)
                    Text("Simulações")
                }.navigationViewStyle(StackNavigationViewStyle())
            SimulationCreationView(viewModel: simulationCreationViewModel, detailViewModel: simulationCreationDetailViewModel, stepViewModel: simulationCreationStepViewModel)
                .tag(1)
                .tabItem {
                    Image(systemName: SFSymbol.chartBarFill.rawValue)
                    Text("Simulação")
                }.navigationViewStyle(StackNavigationViewStyle())
            TalkWithUsView()
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
            SimulationCreationView(viewModel: simulationCreationViewModel, detailViewModel: simulationCreationDetailViewModel, stepViewModel: simulationCreationStepViewModel)
                .tag(1)
                .tabItem {
                    Image(systemName: SFSymbol.chartBarFill.rawValue)
                    Text("Simulação")
                }.navigationViewStyle(StackNavigationViewStyle())
            TalkWithUsView()
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
                StartView(viewModel: startViewModel)
                
            } else {
                LoginView(viewModel: loginViewModel, registerViewModel: registerViewModel, resendPasswordViewModel: resendPasswordViewModel)
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
