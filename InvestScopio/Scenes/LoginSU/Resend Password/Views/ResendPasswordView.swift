//
//  ResendPasswordView.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 20/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI
import JewFeatures

struct ResendPasswordView: View {
    @EnvironmentObject var reachability: Reachability
    @EnvironmentObject var settings: AppSettings
    @ObservedObject var viewModel: ResendPasswordViewModel
    @ObservedObject var kGuardian: KeyboardGuardian
    var hasFinished: () -> Void
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ZStack {
                    
                    BlurView(style: .systemThinMaterial).onTapGesture {
                        self.kGuardian.showField = 0
                        self.viewModel.close = false
                        self.settings.popup = AppPopupSettings()
                        UIApplication.shared.endEditing()
                    }
                    VStack {
                        
                        HStack {
                            Text("Recuperação de Senha").font(Font.system(.largeTitle).bold())
                            Spacer()
                        }
                        .padding()
                        .padding(.top, geometry.safeAreaInsets.top)
                        ResendPasswordFormView(emailText: self.$viewModel.email, close: self.$viewModel.close) {
                            self.viewModel.resendPassword(completion: {
                                self.settings.popup = AppPopupSettings()
                                self.kGuardian.showField = 0
                                self.hasFinished()
                                self.viewModel.email = String()
                            }) { popupSettings in
                                self.settings.popup = popupSettings
                            }
                            
                        }
                        .background(GeometryGetter(rect: self.$kGuardian.rects[2]))
                        
                        HStack {
                            LoadingButton(isLoading: .constant(false), title: "Cancelar", color: Color(.JEWRed()), isFill: false) {
                                self.kGuardian.showField = 0
                                UIApplication.shared.endEditing()
                                self.viewModel.close = true
                                self.settings.popup = AppPopupSettings()
                            }
                            LoadingButton(isLoading: self.$viewModel.showLoading, title: "Recuperar", color: Color("accent"), isFill: true) {
                                UIApplication.shared.endEditing()
                                self.viewModel.resendPassword(completion: {
                                    self.settings.popup = AppPopupSettings()
                                    self.kGuardian.showField = 0
                                    self.hasFinished()
                                    self.viewModel.email = String()
                                }) { popupSettings in
                                    self.settings.popup = popupSettings
                                }
                            }
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                }
                .offset(y: self.viewModel.close ? geometry.size.height : 0)
                .offset(y: self.kGuardian.slide)
                .animation(Animation.spring())
            }
            .edgesIgnoringSafeArea(.all)
            PopupView(text: self.$viewModel.messageSuccess, textColor: .constant(Color.white), backgroundColor: .constant(Color(.JEWDarkDefault())), position: .constant(.bottom), show: self.$viewModel.showSuccess, checkReachability: .constant(false))
        }
    }
}


struct ResendPasswordFormView: View {
    @Binding var emailText: String
    @Binding var close: Bool
    var didResendPasswordAction: (() -> Void)
    var body: some View {
        Form {
            Section(header: Text("Digite seu email").textFont().padding(.top, 16)) {
                FloatingTextField(toolbarBuilder: JEWFloatingTextFieldToolbarBuilder().setToolbar(leftButtons: [], rightButtons: [.ok]), formatBuilder: FloatingTextField.defaultFormatBuilder(placeholder: "Email"), text: $emailText, close: $close,tapOnToolbarButton: { textfield, type in
                    self.didResendPasswordAction()
                }) { textfield, text, isBackspace in
                    self.emailText = text
                }
                .frame(height: 50)
                .listRowBackground(Color(UIColor.systemBackground))
            }
        }
        .animation(.linear)
        .frame(height: 150)
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(16)
        .padding()
    }
}


struct ResendPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResendPasswordView(viewModel: ResendPasswordViewModel.init(service: ResendPasswordService()), kGuardian: .init(textFieldCount: 2)) {
            
        }
    }
}
