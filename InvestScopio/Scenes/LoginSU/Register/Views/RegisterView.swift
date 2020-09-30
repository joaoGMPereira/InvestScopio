//
//  RegisterView.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 20/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI
import JewFeatures

struct RegisterView: View {
    @EnvironmentObject var reachability: Reachability
    @EnvironmentObject var settings: AppSettings
    @ObservedObject var viewModel: RegisterViewModel
    @ObservedObject var kGuardian: KeyboardGuardian
    var hasFinished: () -> Void
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ZStack {
                    
                    BlurView(style: .systemThinMaterial).onTapGesture {
                        self.kGuardian.showField = 0
                        self.viewModel.close = false
                        UIApplication.shared.endEditing()
                    }.edgesIgnoringSafeArea(.all)
                    VStack {
                        
                        HStack {
                            Text("Cadastro").font(Font.system(.largeTitle).bold())
                            Spacer()
                        }
                        .padding()
                        .padding(.top, geometry.safeAreaInsets.top)
                        RegisterFormView(close: self.$viewModel.close, emailText: self.$viewModel.email, passwordText: self.$viewModel.password, passwordConfirmationText: self.$viewModel.confirmationPassword) {
                            self.viewModel.register(completion: {
                                self.settings.popup = AppPopupSettings()
                                self.kGuardian.showField = 0
                                self.hasFinished()
                            }) { popupSettings in
                                self.settings.popup = popupSettings
                            }
                        }
                        .background(GeometryGetter(rect: self.$kGuardian.rects[1]))
                        
                        HStack {
                            LoadingButton(isLoading: .constant(false), isEnable: .constant(true), model: LoadingButtonModel(title: "Cancelar", color: Color(.JEWRed()), isFill: false)) {
                                self.kGuardian.showField = 0
                                self.viewModel.close = true
                                self.settings.popup = AppPopupSettings()
                                UIApplication.shared.endEditing()
                            }
                            LoadingButton(isLoading: self.$viewModel.showLoading, isEnable: .constant(true), model: LoadingButtonModel(title: "Cadastrar", color: Color("accent"), isFill: true)) {
                                UIApplication.shared.endEditing()
                                self.viewModel.register(completion: {
                                    self.settings.popup = AppPopupSettings()
                                    self.kGuardian.showField = 0
                                    self.hasFinished()
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
                .animation(.spring())
            }
            PopupView(text: self.$viewModel.messageSuccess, textColor: .constant(Color.white), backgroundColor: .constant(Color(.JEWDarkDefault())), position: .constant(.bottom), show: self.$viewModel.showSuccess)
        }
    }
}


struct RegisterFormView: View {
    @Binding var close: Bool
    @Binding var emailText: String
    @Binding var passwordText: String
    @Binding var passwordConfirmationText: String
    var didRegisterAction: (() -> Void)
    var body: some View {
        Form {
            Section(header: Text("Digite um email válido").textFont().padding(.top, 16)) {
                FloatingTextField(toolbarBuilder: JEWToolbarBuilder().setToolbar(leftButtons: [], rightButtons: [.ok]), formatBuilder: FloatingTextField.defaultFormatBuilder(), placeholder: .constant("Email"), text: $emailText, formatType: .constant(.none), keyboardType: .constant(.default), close: $close, shouldBecomeFirstResponder: .constant(false), onChanged:  { textfield, text, isBackspace in
                    self.emailText = text
                })
                .frame(height: 50)
                .listRowBackground(Color(.JEWBackground()))
            }
            Section(header: Text("Digite uma senha").textFont()) {
                FloatingTextField(toolbarBuilder: JEWToolbarBuilder().setToolbar(leftButtons: [], rightButtons: [.ok]), formatBuilder: FloatingTextField.defaultFormatBuilder(), placeholder: .constant("Senha"), text: $passwordText, formatType: .constant(.none), keyboardType: .constant(.default), close: $close, shouldBecomeFirstResponder: .constant(false), isSecureTextEntry: true, didBeginEditing: { textfield in
                    self.passwordText = String()
                }, onChanged:  { textfield, text, isBackspace in
                    self.passwordText = text
                })
                .frame(height: 50)
                .listRowBackground(Color(.JEWBackground()))
            }
            Section(header: Text("Confirme sua senha").textFont()) {
                FloatingTextField(toolbarBuilder: JEWToolbarBuilder().setToolbar(leftButtons: [], rightButtons: [.ok]), formatBuilder: FloatingTextField.defaultFormatBuilder(), placeholder: .constant("Confirmar Senha"), text: $passwordConfirmationText, formatType: .constant(.none), keyboardType: .constant(.default), close: $close, shouldBecomeFirstResponder: .constant(false), isSecureTextEntry: true, tapOnToolbarButton: { textfield, type in
                    self.didRegisterAction()
                }, didBeginEditing: { textfield in
                    self.passwordConfirmationText = String()
                }, onChanged:  { textfield, text, isBackspace in
                    self.passwordConfirmationText = text
                })
                .frame(height: 50)
                .listRowBackground(Color(.JEWBackground()))
                
            }
        }
        .animation(.linear)
        .frame(height: 360)
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(radius: 8)
        .padding()
    }
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(viewModel: RegisterViewModel.init(service: RegisterService(repository: RegisterRepository())), kGuardian: .init(textFieldCount: 2)) {
            
        }
    }
}
