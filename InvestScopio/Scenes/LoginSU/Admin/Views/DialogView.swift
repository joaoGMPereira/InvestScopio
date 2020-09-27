//
//  LoginAdminView.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 26/09/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI

struct DialogView: View {
    @Binding var isLoading: Bool
    @Binding var close: Bool
    var titleText: String
    var messageText: String
    var cancelText: String
    var confirmText: String
    var closeCompletion: (() -> Void)?
    var confirmCompletion: (() -> Void)?
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ZStack {
                    BlurView(style: .systemThinMaterial).onTapGesture {
                        self.close = false
                    }.edgesIgnoringSafeArea(.all)
                    VStack {
                        HStack {
                            Text(titleText).font(Font.system(.largeTitle).bold())
                            Spacer()
                        }
                        .padding()
                        .padding(.top, geometry.safeAreaInsets.top)
                        VStack {
                            Text("Atenção!").bold()
                            Text(messageText)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                        .shadow(color: Color("accessoryBackground").opacity(0.8), radius: 8)
                        .padding()
                        
                        HStack {
                            LoadingButton(isLoading: .constant(false), isEnable: .constant(true), model: LoadingButtonModel(title: cancelText, color: Color(.JEWRed()), isFill: false)) {
                                self.close = true
                            }
                            LoadingButton(isLoading: self.$isLoading, isEnable: .constant(true), model: LoadingButtonModel(title: confirmText, color: Color("accent"), isFill: true)) {
                                self.confirmCompletion?()
                            }
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                }
                .offset(y: self.close ? geometry.size.height : 0)
                .animation(.spring())
            }
        }
    }
}

struct DialogView_Previews: PreviewProvider {
    static var previews: some View {
        DialogView(isLoading: .constant(false), close: .constant(false), titleText: "Teste", messageText: "Text", cancelText: "Cancelar", confirmText: "Confirmar") {
            
        } confirmCompletion: {
            
        }

    }
}
