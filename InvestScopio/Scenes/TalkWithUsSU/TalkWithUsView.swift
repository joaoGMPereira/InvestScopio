//
//  TalkWithUsView.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 16/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI
import EnvironmentOverrides
struct TalkWithUsView: View {
    @EnvironmentObject var settings: AppSettings
    var body: some View {
        NavigationView {
            ZStack {
                Color(.JEWBackground())
                ScrollView {
                    ZStack {
                        Button(action: {
                            self.settings.isLogged = false
                        }) {
                            Text("Sair")
                                .foregroundColor(Color.init(.label))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .contentShape(Rectangle())
                        }
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 16)
                .navigationBarTitle("Fale Conosco", displayMode: .large)
            }
        }
    }
}


struct TalkWithUsView_Previews: PreviewProvider {
    static var previews: some View {
        TalkWithUsView().attachEnvironmentOverrides()
    }
}


struct SymbolLoading: View {
    
    @State var animateTrimPath = false
    
    var body: some View {
        GeometryReader { geometry in
        Path { path in
            path.addLines([
                .init(x: geometry.frame(in: .local).minX, y: geometry.frame(in: .local).height),
                .init(x: geometry.frame(in: .local).minX + geometry.frame(in: .local).width/3, y: geometry.frame(in: .local).height * 0.2),
                .init(x: geometry.frame(in: .local).minX + geometry.frame(in: .local).width * 0.6, y: geometry.frame(in: .local).height * 0.9),
                .init(x: geometry.frame(in: .local).minX + geometry.frame(in: .local).width, y: geometry.frame(in: .local).minY)
            ])
        }
         .trim(from: animateTrimPath ? 1/0.99 : 0, to: animateTrimPath ? 1/0.99 : 1)
        .stroke(Color(.JEWDefault()), style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
        .animation(Animation.easeInOut(duration:2).repeatForever(autoreverses: true))
        }
        .onAppear() {
            self.animateTrimPath.toggle()
        }
    }
}

struct Indicator_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment:.center) {
        SymbolLoading().frame(width: 200, height: 100)
        }
    }
}
