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
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                HeaderView()
                ScrollView {
                    LoginFormView(emailText: $viewModel.email, passwordText: $viewModel.password, saveData: $viewModel.saveData, rects: $kGuardian.rects) {
                        UIApplication.shared.endEditing()
                        self.viewModel.login(completion: {
                            self.settings.popup = AppPopupSettings()
                            self.settings.loggingState = .normal
                            self.settings.tabSelection = 1
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
                        viewModel.adminClose = false
                    }, didRegisterAction: {
                        UIApplication.shared.endEditing()
                        self.kGuardian.showField = 1
                        self.registerViewModel.close = false
                        self.settings.popup = AppPopupSettings()
                    }) {
                        UIApplication.shared.endEditing()
                        self.viewModel.login(completion: {
                            self.settings.popup = AppPopupSettings()
                            self.settings.tabSelection = 1
                            self.settings.loggingState = .normal
                            
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
            
            DialogView(isLoading: $viewModel.adminLoading, close: $viewModel.adminClose, titleText: "Acesso sem Login", messageText: "Sem efetuar o login você não terá acesso ao seu histórico de simulações.", cancelText: "Cancelar", confirmText: "Confirmar") {
                
            } confirmCompletion: {
                self.viewModel.loginAdmin(completion: {
                    self.settings.tabSelection = 1
                    self.settings.popup = AppPopupSettings()
                    self.settings.loggingState = .admin
                }) { popupSettings in
                self.settings.popup = popupSettings
                }
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
