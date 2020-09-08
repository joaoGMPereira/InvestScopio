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
    var body: some View {
        ZStack {
            if settings.isLogged {
                TabView {
                    SimulationsView(viewModel: simulationsViewModel)
                        .tag(0)
                        .tabItem {
                            Image(systemName: SFSymbol.listBullet.rawValue)
                            Text("Simulações")
                    }
                    SimulationCreationView(viewModel: simulationCreationViewModel, stepViewModel: simulationCreationStepViewModel)
                        .tag(1)
                        .tabItem {
                            Image(systemName: SFSymbol.chartBarFill.rawValue)
                            Text("Simulação")
                    }
                    TalkWithUsView()
                        .tag(2)
                        .tabItem {
                            Image(systemName: SFSymbol.personFill.rawValue)
                            Text("Fale conosco")
                    }
                }
                .accentColor(Color(.JEWDefault()))
                .attachEnvironmentOverrides()
            } else {
                LoginView(viewModel: loginViewModel, registerViewModel: registerViewModel, resendPasswordViewModel: resendPasswordViewModel)
                    .attachEnvironmentOverrides()
                
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
    @Published var popup = AppPopupSettings()
}

class AppPopupSettings: ObservableObject {
    @Published var message: String
    @Published var textColor: Color
    @Published var backgroundColor: Color
    @Published var position: Position
    @Published var show: Bool
    
    init(message: String = String(), textColor: Color = .clear, backgroundColor: Color = .clear, position: Position = .top, show: Bool = false) {
        self.message = message
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.position = position
        self.show = show
    }
}
