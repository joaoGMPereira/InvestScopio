//
//  LoadinButton.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 19/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI

struct LoadingButton: View {
    @Binding var isLoading: Bool
    var title: String
    var color: Color
    var isFill: Bool
    var action: (() -> Void)?
    var body: some View {
        Button(action: {
            self.action?()
        }) {
            Group {
            if isLoading == false {
                Text(title)
                    .foregroundColor(isFill ? .white : color)
                    .textFont()
            } else {
                LoadingView(showLoading: $isLoading, shape: .constant(isFill ? .white : color), size: .constant(22), lineWidth: .constant(2))
            }
            }.frame(minWidth: .none, maxWidth: .infinity, minHeight: .none, maxHeight: 44, alignment: .center)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 44)
        .background(RoundedRectangle(cornerRadius: 22)
        .foregroundColor(isFill ? color : .clear))
        .background(RoundedRectangle(cornerRadius: 22, style: .continuous)
        .stroke(isFill ? .clear : color, style: StrokeStyle(lineWidth: isFill ? 0 : 2)))
    }
}

struct LoadingButton_Previews: PreviewProvider {
    static var previews: some View {
        LoadingButton(isLoading: .constant(false), title: "Teste", color: Color.red, isFill: true) {
            
        }.padding()
    }
}

