//
//  DoubleButtons.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 27/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI

struct DoubleButtons: View {
    @Binding var firstIsLoading: Bool
    @Binding var secondIsLoading: Bool
    @Binding var firstIsEnable: Bool
    @Binding var secondIsEnable: Bool
    var firstModel: LoadingButtonModel
    var secondModel: LoadingButtonModel
    var background: Color
    var firstCompletion: () -> Void
    var secondCompletion: () -> Void
    var body: some View {
        HStack(spacing: 8) {
            LoadingButton(isLoading: $firstIsLoading, isEnable: $firstIsEnable, model: firstModel, action: firstCompletion)
            LoadingButton(isLoading: $secondIsLoading, isEnable: $secondIsEnable, model: secondModel, action: secondCompletion)
        }
        .background(background)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}
