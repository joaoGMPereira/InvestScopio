//
//  LoginView.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 17/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI

class Login: ObservableObject {
    
}

struct LoginView: View {
    @State var email = String()
    @State var password = String()
    @State var saveData = false
    @State var hasAppeared = false
    
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 1)
    
    var body: some View {
        UITableView.appearance().backgroundColor = .clear
        return
            VStack(spacing: 16) {
                HeaderView()
                ScrollView {
                    LoginFormView(emailText: $email, passwordText: $password, saveData: $saveData)
                    BottomButtonsView(rects: $kGuardian.rects, hasAppeared: $hasAppeared)
                    
                }.offset(y: kGuardian.slide).animation( .easeInOut(duration: hasAppeared ? 0.3 : 0))
            }
            .padding(.top, 32)
            .background(Color(UIColor.systemBackground))
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                self.kGuardian.addObserver()
            }.onDisappear {
                self.hasAppeared = false
                self.kGuardian.removeObserver()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView(email: String(), password: String(), saveData: false)
            LoginView(email: String(), password: String(), saveData: false).previewDevice("iPad Pro (9.7-inch)")
            LoginView(email: String(), password: String(), saveData: false).environment(\.colorScheme, .dark)
        }
    }
}

struct LoginFormView: View {
    @Binding var emailText: String
    @Binding var passwordText: String
    @Binding var saveData:Bool
    var body: some View {
        Form {
            Section(header: Text("Digite seu email").padding(.top, 16)) {
                TextField("Email", text: $emailText)
                    .listRowBackground(Color(UIColor.systemBackground))
            }
            Section(header: Text("Digite sua senha")) {
                TextField("Senha", text: $emailText)
                    .listRowBackground(Color(UIColor.systemBackground))
            }
            Section {
                Toggle(isOn: $saveData) { Text("Salvar dados") }
                    .listRowBackground(Color(UIColor.systemBackground))
            }
        }
        .animation(.none)
        .frame(height: 290.0)
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(16)
        .padding()
    }
}

struct HeaderView: View {
    var body: some View {
        HStack {
            Image("iconBig").resizable().scaledToFit().frame(width: 64, height: 64)
            Text("InvestScopio").font(.system(.largeTitle, design: .rounded)).bold()
            Spacer()
        }
    }
}

struct BottomButtonsView: View {
    @Binding var rects: Array<CGRect>
    @Binding var hasAppeared: Bool
    var body: some View {
        Group {
            HStack {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Cadastrar").foregroundColor(Color("accent"))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(RoundedRectangle(cornerRadius: 22)
                .stroke(Color("accent"), style: StrokeStyle(lineWidth: 1)))
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Login")
                        .foregroundColor(.white)
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 22).foregroundColor(Color("accent")))
                .background(GeometryGetter(rect: $rects[0]))
                
            }.padding(.horizontal)
            
            HStack {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Esqueceu sua Senha?")
                        .underline()
                        .foregroundColor(Color("accent"))
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Acesso sem Login")
                        .underline()
                        .foregroundColor(Color("accent"))
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                
            }.padding(.horizontal)
        }.onAppear {
                self.hasAppeared = true
                print("🟢 OnAppear")
        }
    }
}
