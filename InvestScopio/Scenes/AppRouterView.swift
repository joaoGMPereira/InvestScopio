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
            if settings.isLogged {
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
            } else {
                if settings.hasUserSaved {
                    StartView(viewModel: startViewModel)
                } else {
                    LoginView(viewModel: loginViewModel, registerViewModel: registerViewModel, resendPasswordViewModel: resendPasswordViewModel)
                        .attachEnvironmentOverrides()
                }
                
            }
            PopupView(text: self.$settings.popup.message, textColor: self.$settings.popup.textColor, backgroundColor: self.$settings.popup.backgroundColor, position: self.$settings.popup.position, show: self.$settings.popup.show, checkReachability: .constant(true))
        }
    }
}

struct LoginRouterView_Previews: PreviewProvider {
    static var previews: some View {
        AppRouterView().environmentObject(AppSettings())
    }
}

class AppSettings: ObservableObject {
    @Published var isLogged = false
    @Published var hasUserSaved: Bool = (INVSKeyChainWrapper.retrieveBool(withKey: INVSConstants.LoginKeyChainConstants.hasUserLogged.rawValue) ?? false)
    @Published var tabSelection = 1 {
        didSet {
            tabSelected?(tabSelection)
        }
    }
    @Published var popup = AppPopupSettings()
    
    var tabSelected: ((Int) -> Void)?
}

class AppPopupSettings: ObservableObject {
    @Published var message: String
    @Published var textColor: Color
    @Published var backgroundColor: Color
    @Published var position: Position
    @Published var show: Bool
    
    init(message: String = String(), textColor: Color = .clear, backgroundColor: Color = .clear, position: Position = .top, show: Bool = false) {
        self.message = "Atenção\n" + message
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.position = position
        self.show = show
    }
}
