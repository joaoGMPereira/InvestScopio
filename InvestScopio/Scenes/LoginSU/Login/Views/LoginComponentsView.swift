//
//  LoginComponentsView.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 18/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI
import JewFeatures

struct HeaderView: View {
    var body: some View {
        HStack {
            Image("iconBig")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
            Text("InvestScopio")
                .font(.system(.largeTitle, design: .rounded))
                .bold()
            Spacer()
        }
        .padding(.leading, 16)
        .padding(.top, 30)
    }
}

struct LoginFormView: View {
    @Binding var emailText: String
    @Binding var passwordText: String
    @Binding var saveData: Bool
    @Binding var rects: Array<CGRect>
    var didLoginAction: (() -> Void)
    var body: some View {
        Form {
            Section(header: Text("Digite seu email").textFont().padding(.top, 16)) {
                FloatingTextField(toolbarBuilder: JEWFloatingTextFieldToolbarBuilder().setToolbar(leftButtons: [], rightButtons: [.ok]), formatBuilder: FloatingTextField.defaultFormatBuilder(), placeholder: .constant("Email"), text: $emailText, formatType: .constant(.none), keyboardType: .constant(.default), close: .constant(false), shouldBecomeFirstResponder: .constant(false)) { textfield, text, isBackspace in
                    self.emailText = text
                }
                .frame(height: 50)
                .listRowBackground(Color(.JEWBackground()))
            }
            Section(header: Text("Digite sua senha").textFont()) {
                FloatingTextField(toolbarBuilder: JEWFloatingTextFieldToolbarBuilder().setToolbar(leftButtons: [], rightButtons: [.ok]), formatBuilder: FloatingTextField.defaultFormatBuilder(), placeholder: .constant("Senha"), text: $passwordText, formatType: .constant(.none), keyboardType: .constant(.default), close: .constant(false), shouldBecomeFirstResponder: .constant(false), isSecureTextEntry: true, tapOnToolbarButton: { textfield, type in
                    self.didLoginAction()
                }, didBeginEditing: { textfield in
                    self.passwordText = String()
                }) { textfield, text, isBackspace in
                    self.passwordText = text
                }
                .frame(height: 50)
                .listRowBackground(Color(.JEWBackground()))
            }
            Section {
                Toggle(isOn: $saveData) { Text("Salvar dados").textFont() }
                    .listRowBackground(Color(.JEWBackground()))
            }
        }
        .background(GeometryGetter(rect: self.$rects[0]))
        .animation(.none)
        .frame(height: 320.0)
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(16)
        .padding()
    }
}

struct BottomButtonsView: View {
    @Binding var hasAppeared: Bool
    @Binding var isLoading: Bool
    @State var size: CGFloat = 15
    var didResendPasswordAction: (() -> Void)
    var didAdminLoginAction: (() -> Void)
    var didRegisterAction: (() -> Void)
    var didLoginAction: (() -> Void)
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                LoadingButton(isLoading: .constant(false), model: LoadingButtonModel(title: "Cadastrar", color: Color("accent"), isFill: false)) {
                    self.didRegisterAction()
                }
                LoadingButton(isLoading: $isLoading, model: LoadingButtonModel(title: "Login", color: Color("accent"), isFill: true)) {
                    self.didLoginAction()
                }
            }.padding(.horizontal)
            
            VStack(alignment: .center) {
                Button(action: {
                    self.didResendPasswordAction()
                }) {
                    Text("Esqueceu sua Senha?")
                        .underline()
                        .foregroundColor(Color("accent"))
                        .textFont()
                    
                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: 44)
                Button(action: {
                    self.didAdminLoginAction()
                }) {
                    Text("Acesso sem Login")
                        .underline()
                        .foregroundColor(Color("accent"))
                        .textFont()
                    
                }
                .frame(minHeight: 44)
                .frame(maxWidth: .infinity)
                
            }.padding(.horizontal)
        }.onAppear {
            self.hasAppeared = true
        }
    }
}
