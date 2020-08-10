//
//  PopupView.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 19/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI

enum Position {
    case top
    case bottom
    
    func offSet(geometry: GeometryProxy) -> CGFloat {
        switch self {
        case .top:
            return geometry.safeAreaInsets.top
        case .bottom:
            return 16
        }
    }
    
    func padding() -> Edge.Set {
        switch self {
        case .top:
            return .bottom
        case .bottom:
            return .top
        }
    }
    
    func cornerRadius() -> UIRectCorner {
        switch self {
        case .top:
            return [.bottomRight, .bottomLeft]
        case .bottom:
            return [.topRight, .topLeft]
        }
    }
    
    func position(show: Bool, height: CGFloat, safeAreaInsets: EdgeInsets) -> CGFloat {
        switch self {
        case .top:
            return show ? 0 : -height - safeAreaInsets.top
        case .bottom:
            return show ? 0 : height + safeAreaInsets.bottom
        }
    }
}


struct PopupView: View {
    @EnvironmentObject var reachability: Reachability
    @Binding var text: String
    @Binding var textColor: Color
    @Binding var backgroundColor: Color
    @Binding var position: Position
    
    @Binding var show: Bool
    
    @State var animate: Bool = false
    
    @State var rect: CGRect = .zero
    let padding: CGFloat = 16
    
    var body: some View {
        GeometryReader { geometry in
            self.body(position: self.position, geometry: geometry)
        }
    }
    
    func body(position: Position, geometry: GeometryProxy) -> some View {
        return VStack {
            if position == .bottom {
                Spacer()
            }
            HStack {
            Text(self.text).textFont()
                Spacer()
            }
                .foregroundColor(self.textColor)
                .frame(width: geometry.size.width - (self.padding * 2))
                .padding(.horizontal, self.padding)
                .offset(y: position.offSet(geometry: geometry))
                .padding(.bottom, position.offSet(geometry: geometry) + self.padding)
                .background(self.backgroundColor)
                .overlay(GeometryReader { geometry in
                    Group { () -> AnyView in
                        DispatchQueue.main.async {
                            let updatedRect = geometry.frame(in: .global)
                            self.rect = updatedRect
                        }
                        
                        return AnyView(Color.clear)
                    }
                })
                .cornerRadius(16, corners: position.cornerRadius())
            if position == .top {
                Spacer()
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .offset(y: position.position(show: show, height: rect.height, safeAreaInsets: geometry.safeAreaInsets))
        .animation(animate ? Animation.easeInOut(duration: 0.3): .none)
        .onTapGesture {
            self.show = false
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.animate = true
            }
        }
    }
}
