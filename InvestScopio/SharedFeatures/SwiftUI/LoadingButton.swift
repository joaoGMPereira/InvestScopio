//
//  LoadinButton.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 19/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI
import JewFeatures
struct LoadingButton: View {
    @Environment(\.sizeCategory) private var defaultSizeCategory: ContentSizeCategory
    @Binding var isLoading: Bool
    var model: LoadingButtonModel
    var action: (() -> Void)?
    var body: some View {
        Button(action: {
            self.action?()
        }) {
            Group {
            if isLoading == false {
                Text(model.title)
                    .foregroundColor(model.isFill ? .white : model.color)
                    .textFont()
            } else {
                LoadingView(showLoading: $isLoading, shape: .constant(model.isFill ? .white : model.color), size: .constant(22), lineWidth: .constant(2))
            }
            }.frame(minWidth: .none, maxWidth: .infinity, minHeight: .none, maxHeight: dynamicButtonHeight(), alignment: .center)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 44)
        .background(RoundedRectangle(cornerRadius: 22)
        .foregroundColor(model.isFill ? model.color : .clear))
        .background(RoundedRectangle(cornerRadius: 22, style: .continuous)
        .stroke(model.isFill ? .clear : model.color, style: StrokeStyle(lineWidth: model.isFill ? 0 : 2)))
    }
    
    func dynamicButtonHeight() -> CGFloat {
        let defaultHeight: CGFloat = 44
        switch defaultSizeCategory {
        
        case .extraSmall, .small, .medium, .large:
            return defaultHeight
        case .extraLarge:
            return defaultHeight*1.4
        case .extraExtraLarge:
            return defaultHeight*1.8
        case .extraExtraExtraLarge:
            return defaultHeight*2.2
        case .accessibilityMedium:
            return defaultHeight*2.6
        case .accessibilityLarge:
            return defaultHeight*3
        case .accessibilityExtraLarge:
            return defaultHeight*3.4
        case .accessibilityExtraExtraLarge:
            return defaultHeight*3.8
        case .accessibilityExtraExtraExtraLarge:
            return defaultHeight*4.2
        @unknown default:
            return defaultHeight
        }
    }
}

struct LoadingButtonModel {
    var title: String
    var color: Color
    var isFill: Bool
}

struct LoadingButton_Previews: PreviewProvider {
    static var previews: some View {
        LoadingButton(isLoading: .constant(false), model: LoadingButtonModel(title: "Teste", color: Color(.JEWRed()), isFill: true)) {
            
        }.padding()
    }
}

