//
//  Step.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 30/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI

struct Step: View {
    @Binding var passed: Int
    @Binding var progress: Int
    @Binding var quantity: CGFloat
    var progressedColor: Color
    var unprogressedColor: Color
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 4) {
                ForEach(Range(1...Int(self.quantity)), id: \.self) { index in
                    Text(index <= self.passed ? "" : "\(index)").foregroundColor(Color.clear).frame(width: (geometry.frame(in: .global).width - (4*self.quantity))/self.quantity).overlay(index <= self.progress ? self.progressedColor : self.unprogressedColor).clipShape(RoundedRectangle(cornerRadius: 8))
                }.animation(.easeInOut)
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        Step(passed: .constant(2), progress: .constant(3), quantity: .constant(7), progressedColor: .red, unprogressedColor: .gray)
    }
}
