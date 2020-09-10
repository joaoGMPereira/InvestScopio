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
    @EnvironmentObject var settings: AppSettings
    @ObservedObject var viewModel: LoginViewModel
    @ObservedObject var registerViewModel: RegisterViewModel
    @ObservedObject var resendPasswordViewModel: ResendPasswordViewModel
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 3)
    @State var hasAppeared = false
    @State var showRegister = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                HeaderView()
                ScrollView {
                    LoginFormView(emailText: $viewModel.email, passwordText: $viewModel.password, saveData: $viewModel.saveData, rects: $kGuardian.rects) {
                        UIApplication.shared.endEditing()
                        self.viewModel.login(completion: {
                            self.settings.popup = AppPopupSettings()
                            self.settings.isLogged = true
                        }) { popupSettings in
                        self.settings.popup = popupSettings
                        }
                    }
                    BottomButtonsView(hasAppeared:
                        $hasAppeared, isLoading: $viewModel.showLoading, didResendPasswordAction: {
                            UIApplication.shared.endEditing()
                            self.kGuardian.showField = 2
                            self.resendPasswordViewModel.close = false
                    }, didAdminLoginAction: {
                        self.viewModel.login(completion: {
                            self.settings.popup = AppPopupSettings()
                            self.settings.isLogged = true
                            self.settings.popup = AppPopupSettings()
                        }) { popupSettings in
                        self.settings.popup = popupSettings
                        }
                    }, didRegisterAction: {
                        UIApplication.shared.endEditing()
                        self.kGuardian.showField = 1
                        self.registerViewModel.close = false
                        self.settings.popup = AppPopupSettings()
                    }) {
                        UIApplication.shared.endEditing()
                        self.viewModel.login(completion: {
                            self.settings.popup = AppPopupSettings()
                            self.settings.isLogged = true
                        }) { popupSettings in
                        self.settings.popup = popupSettings
                        }
                    }
                    
                }.offset(y: kGuardian.slide).animation( .easeInOut(duration: hasAppeared ? 0.3 : 0))
            }
            .padding(.top, 32)
            .background(Color("primaryBackground"))
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                self.kGuardian.addObserver()
                self.viewModel.checkUserSavedEmail()
            }.onDisappear {
                self.hasAppeared = false
                self.kGuardian.removeObserver()
            }
            RegisterView(viewModel: registerViewModel, kGuardian: kGuardian) {
                self.viewModel.email = self.registerViewModel.email
            }
            
            ResendPasswordView(viewModel: resendPasswordViewModel, kGuardian: kGuardian) {
                self.viewModel.email = self.resendPasswordViewModel.email
            }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView(viewModel: LoginViewModel(service: LoginService(webRepository: LoginWebRepository())), registerViewModel: RegisterViewModel(service: RegisterService(repository: RegisterRepository())), resendPasswordViewModel: ResendPasswordViewModel(service: ResendPasswordService())).environmentObject(Reachability())
            LoginView(viewModel: LoginViewModel(service: LoginService(webRepository: LoginWebRepository())), registerViewModel: RegisterViewModel(service: RegisterService(repository: RegisterRepository())), resendPasswordViewModel: ResendPasswordViewModel(service: ResendPasswordService())).previewDevice("iPad Pro (9.7-inch)").environmentObject(Reachability())
            LoginView(viewModel: LoginViewModel(service: LoginService(webRepository: LoginWebRepository())), registerViewModel: RegisterViewModel(service: RegisterService(repository: RegisterRepository())), resendPasswordViewModel: ResendPasswordViewModel(service: ResendPasswordService())).environment(\.colorScheme, .dark).environmentObject(Reachability())
        }
    }
}
