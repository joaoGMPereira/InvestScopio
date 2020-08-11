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
                    }
                    VStack {
                        
                        HStack {
                            Text("Cadastro").font(Font.system(.largeTitle).bold())
                            Spacer()
                        }
                        .padding()
                        .padding(.top, geometry.safeAreaInsets.top)
                        RegisterFormView(close: self.$viewModel.close, emailText: self.$viewModel.email, passwordText: self.$viewModel.password, passwordConfirmationText: self.$viewModel.confirmationPassword) {
                            self.viewModel.register() {
                                self.kGuardian.showField = 0
                                self.hasFinished()
                            }
                        }
                        .background(GeometryGetter(rect: self.$kGuardian.rects[1]))
                        
                        HStack {
                            LoadingButton(isLoading: .constant(false), title: "Cancelar", color: Color.red, isFill: false) {
                                self.kGuardian.showField = 0
                                self.viewModel.close = true
                                UIApplication.shared.endEditing()
                            }
                            LoadingButton(isLoading: self.$viewModel.showLoading, title: "Cadastrar", color: Color("accent"), isFill: true) {
                                UIApplication.shared.endEditing()
                                self.viewModel.register() {
                                    self.kGuardian.showField = 0
                                    self.hasFinished()
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
            self.showError(text: self.$viewModel.messageError, textColor: .constant(Color.white), backgroundColor: .constant(Color.red), position: .constant(.top), show: self.$viewModel.showError)
            PopupView(text: self.$viewModel.messageSuccess, textColor: .constant(Color.white), backgroundColor: .constant(Color(.JEWDarkDefault())), position: .constant(.bottom), show: self.$viewModel.showSuccess)
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


struct RegisterFormView: View {
    @Binding var close: Bool
    @Binding var emailText: String
    @Binding var passwordText: String
    @Binding var passwordConfirmationText: String
    var didRegisterAction: (() -> Void)
    var body: some View {
        Form {
            Section(header: Text("Digite um email válido").textFont().padding(.top, 16)) {
                FloatingTextField(toolbarBuilder: JEWFloatingTextFieldToolbarBuilder().setToolbar(leftButtons: [], rightButtons: [.ok]), formatBuilder: FloatingTextField.defaultFormatBuilder(placeholder: "Email"), text: $emailText, close: $close) { textfield, text, isBackspace in
                    self.emailText = text
                }
                .frame(height: 50)
                .listRowBackground(Color(UIColor.systemBackground))
            }
            Section(header: Text("Digite uma senha").textFont()) {
                FloatingTextField(toolbarBuilder: JEWFloatingTextFieldToolbarBuilder().setToolbar(leftButtons: [], rightButtons: [.ok]), formatBuilder: FloatingTextField.defaultFormatBuilder(placeholder: "Senha"), text: $passwordText, close: $close, isSecureTextEntry: true, didBeginEditing: { textfield in
                    self.passwordText = String()
                }) { textfield, text, isBackspace in
                    self.passwordText = text
                }
                .frame(height: 50)
                .listRowBackground(Color(UIColor.systemBackground))
            }
            Section(header: Text("Confirme sua senha").textFont()) {
                FloatingTextField(toolbarBuilder: JEWFloatingTextFieldToolbarBuilder().setToolbar(leftButtons: [], rightButtons: [.ok]), formatBuilder: FloatingTextField.defaultFormatBuilder(placeholder: "Confirmar Senha"), text: $passwordConfirmationText, close: $close, isSecureTextEntry: true, tapOnToolbarButton: { textfield, type in
                    self.didRegisterAction()
                }, didBeginEditing: { textfield in
                    self.passwordConfirmationText = String()
                }) { textfield, text, isBackspace in
                    self.passwordConfirmationText = text
                }
                .frame(height: 50)
                .listRowBackground(Color(UIColor.systemBackground))
                
            }
        }
        .animation(.linear)
        .frame(height: 360)
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(16)
        .padding()
    }
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(viewModel: RegisterViewModel.init(service: RegisterService(repository: RegisterRepository())), kGuardian: .init(textFieldCount: 2)) {
            
        }
    }
}
