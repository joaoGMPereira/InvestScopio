//
//  LoginView.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 17/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var reachability: Reachability
    @ObservedObject var viewModel: LoginViewModel
    @ObservedObject var registerViewModel = RegisterViewModel(service: RegisterService(repository: RegisterRepository()))
    @ObservedObject var resendPasswordViewModel = ResendPasswordViewModel(service: ResendPasswordService())
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 3)
    @State var hasAppeared = false
    @State var showRegister = false
    
    var body: some View {
        UITableView.appearance().backgroundColor = .clear
        return ZStack {
            VStack(spacing: 16) {
                HeaderView()
                ScrollView {
                    LoginFormView(emailText: $viewModel.email, passwordText: $viewModel.password, saveData: $viewModel.saveData, rects: $kGuardian.rects) {
                        UIApplication.shared.endEditing()
                        self.viewModel.login()
                    }
                    BottomButtonsView(hasAppeared:
                        $hasAppeared, isLoading: $viewModel.showLoading, didResendPasswordAction: {
                            UIApplication.shared.endEditing()
                            self.kGuardian.showField = 2
                            self.resendPasswordViewModel.close = false
                            self.viewModel.showError = false
                    }, didAdminLoginAction: {
                        self.viewModel.showSimulations = true
                    }, didRegisterAction: {
                        UIApplication.shared.endEditing()
                        self.kGuardian.showField = 1
                        self.registerViewModel.close = false
                        self.viewModel.showError = false
                    }) {
                        UIApplication.shared.endEditing()
                        self.viewModel.login()
                    }
                    
                }.offset(y: kGuardian.slide).animation( .easeInOut(duration: hasAppeared ? 0.3 : 0))
            }
            .padding(.top, 32)
            .background(Color(UIColor.systemBackground))
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                self.kGuardian.addObserver()
                self.viewModel.checkUserSavedEmail()
            }.onDisappear {
                self.hasAppeared = false
                self.kGuardian.removeObserver()
            }
            
            showError(text: $viewModel.messageError, textColor: .constant(Color.white), backgroundColor: .constant(Color.red), position: .constant(.top), show: $viewModel.showError)
            
            RegisterView(viewModel: registerViewModel, kGuardian: kGuardian) {
                self.viewModel.email = self.registerViewModel.email
            }
            
            ResendPasswordView(viewModel: resendPasswordViewModel, kGuardian: kGuardian) {
                self.viewModel.email = self.resendPasswordViewModel.email
            }
        }.sheet(isPresented: self.$viewModel.showSimulations) {
            SimulationsView(viewModel: SimulationsViewModel(service: SimulationsService(repository: SimulationsRepository()))).attachEnvironmentOverrides().onDisappear {
                self.viewModel.showSimulations = false
            }
        }
    }
    
    func showError(text: Binding<String>, textColor: Binding<Color>, backgroundColor: Binding<Color>, position: Binding<Position>, show: Binding<Bool>) -> some View {
        var updatedShowError = show
        var updatedText = text
        var updatedBackgroundColor = backgroundColor
        if reachability.isConnected == false {
            updatedShowError = .constant(true)
            updatedText = .constant("Atenção\nVocê está desconectado, verifique sua conexão!")
            updatedBackgroundColor = .constant(Color(.JEWDarkDefault()))
        }
        return PopupView(text: updatedText, textColor: textColor, backgroundColor: updatedBackgroundColor, position: position, show: updatedShowError)
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView(viewModel: LoginViewModel(service: LoginService(webRepository: LoginWebRepository()))).environmentObject(Reachability())
            LoginView(viewModel: LoginViewModel(service: LoginService(webRepository: LoginWebRepository()))).previewDevice("iPad Pro (9.7-inch)").environmentObject(Reachability())
            LoginView(viewModel: LoginViewModel(service: LoginService(webRepository: LoginWebRepository()))).environment(\.colorScheme, .dark).environmentObject(Reachability())
        }
    }
}
