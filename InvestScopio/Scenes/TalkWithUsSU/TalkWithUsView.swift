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
            List {
                Section {
                    Button(action: {
                        self.settings.isLogged = false
                    }) {
                        Text("Sair")
                            .foregroundColor(Color.init(.label))
                            
                            .contentShape(Rectangle())
                    }
                }
                .frame(height: 50)
                .listRowBackground(Color(UIColor.systemGray6))
            }
            .padding(.top, 16)
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
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
