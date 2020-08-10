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
                        UIApplication.shared.endEditing()
                    }
                    VStack {
                        
                        HStack {
                            Text("Recuperação de Senha").font(Font.system(.largeTitle).bold())
                            Spacer()
                        }
                        .padding()
                        .padding(.top, geometry.safeAreaInsets.top)
                        ResendPasswordFormView(emailText: self.$viewModel.email) {
                            self.viewModel.resendPassword() {
                                self.kGuardian.showField = 0
                                self.hasFinished()
                            }
                        }
                        .background(GeometryGetter(rect: self.$kGuardian.rects[2]))
                        
                        HStack {
                            LoadingButton(isLoading: .constant(false), title: "Cancelar", color: Color.red, isFill: false) {
                                self.kGuardian.showField = 0
                                UIApplication.shared.endEditing()
                                self.viewModel.close = true
                            }
                            LoadingButton(isLoading: self.$viewModel.showLoading, title: "Recuperar", color: Color("accent"), isFill: true) {
                                UIApplication.shared.endEditing()
                                self.viewModel.resendPassword() {
                                    self.kGuardian.showField = 0
                                    self.hasFinished()
                                    self.viewModel.email = String()
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


struct ResendPasswordFormView: View {
    @Binding var emailText: String
    var didResendPasswordAction: (() -> Void)
    var body: some View {
        Form {
            Section(header: Text("Digite seu email").textFont().padding(.top, 16)) {
                FloatingTextField(toolbarBuilder: JEWFloatingTextFieldToolbarBuilder().setToolbar(leftButtons: [], rightButtons: [.ok]), formatBuilder: FloatingTextField.defaultFormatBuilder(placeholder: "Email"), text: $emailText) { textfield, text, isBackspace in
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
