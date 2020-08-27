//
//  LoadingView.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 19/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI
import JewFeatures

struct LoadingView<ShapeLoading>: View where ShapeLoading: ShapeStyle {
    @State var animate = false
    @Binding var showLoading: Bool
    @Binding var shape: ShapeLoading
    @Binding var size: CGFloat
    @Binding var lineWidth: CGFloat
    var body: some View {
        ZStack {
            Group {
                Circle()
                    .trim(from: 0, to: 0.05)
                    .stroke(shape, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .frame(width: size, height: size)
                    .rotationEffect(Angle.init(degrees: animate ? 360 : 0))
                Circle()
                    .trim(from: animate ? 1/0.99 : 0, to: animate ? 1/0.99 : 1)
                    .stroke(shape, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .frame(width: size, height: size)
                    .rotationEffect(Angle.init(degrees: animate ? 360 : 0))
            }
            .onAppear {
                self.animate = true
            }.animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true))
            
        }.opacity(showLoading ? 1 : 0)
            .animation(Animation.linear(duration: 0.3))
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(showLoading: .constant(true), shape: .constant(Color(.JEWRed())), size: .constant(44), lineWidth: .constant(4))
    }
}
