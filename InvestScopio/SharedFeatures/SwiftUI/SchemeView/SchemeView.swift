//
//  SchemeView.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 30/09/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI
import JewFeatures

struct SchemeView: View {
    var selectedCompletion: (() -> Void)?
    var body: some View {
        Group {
            if Scheme.scheme == .Debug {
                Text("Selecione o ambiente").textFont().contextMenu {
                    ForEach(0..<Int(Scheme.allCases.count), id: \.self) { index in
                        Button(Scheme.allCases[index].rawValue) {
                            let selectedScheme = Scheme.allCases[index]
                            AppInitialization.setup(scheme: selectedScheme)
                            selectedCompletion?()
                        }
                    }
                }
            }
        }
    }
}

struct SchemeView_Previews: PreviewProvider {
    static var previews: some View {
        SchemeView {
            
        }
    }
}
