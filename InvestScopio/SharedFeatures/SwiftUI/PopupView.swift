//
//  PopupView.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 19/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI
import JewFeatures

enum PopupDirection {
    case down(_ translation: CGFloat)
    case up(_ translation: CGFloat)
    
    static func getDirection(_ translation: CGFloat) -> PopupDirection {
        return translation > 0 ? .down(translation) : .up(translation)
    }
    
    func finishAnimation() -> Bool {
        switch self {
        case .down(let translation):
            return translation > 20
        case .up(let translation):
            return translation < -20
        }
    }
}

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
    @Binding var checkReachability: Bool
    
    @State var animate: Bool = false
    
    @State var rect: CGRect = .zero
    @State var dismissMovement: CGFloat = .zero
    let padding: CGFloat = 16
    
    init(text: Binding<String>, textColor: Binding<Color>, backgroundColor: Binding<Color>, position: Binding<Position>, show: Binding<Bool>, checkReachability: Binding<Bool> = .constant(false)) {
        self._text = text
        self._textColor = textColor
        self._backgroundColor = show.wrappedValue ? backgroundColor : .constant(.clear)
        self._position = position
        self._show = show
        self._checkReachability = checkReachability
    }
    
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
                Text(updatedText).textFont()
                Spacer()
            }
            .foregroundColor(updatedTextColor)
            .frame(width: geometry.size.width - (self.padding * 2))
            .padding(.horizontal, self.padding)
            .offset(y: position.offSet(geometry: geometry))
            .padding(.bottom, position.offSet(geometry: geometry) + self.padding)
            .background(updatedBackgroundColor)
            .overlay(GeometryReader { geometry in
                Group { () -> AnyView in
                    let updatedRect = geometry.frame(in: .global)
                    DispatchQueue.main.async {
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
        .offset(y: position.position(show: updatedShow, height: rect.height, safeAreaInsets: geometry.safeAreaInsets) - dismissMovement)
        .animation(animate ? Animation.easeInOut(duration: 0.3): .none)
        .onTapGesture {
            self.show = false
        }
        .gesture(
            DragGesture()
                .onChanged({ (value) in
                    dismissMovement = -value.translation.height
                    let direction = PopupDirection.getDirection(value.translation.height)
                
                    switch direction {
                    case .down:
                        if position != .bottom {
                            dismissMovement = .zero
                        }
                    case .up:
                        if position != .top {
                            dismissMovement = .zero
                        }
                    }
                })
                .onEnded({ (value) in
                    let direction = PopupDirection.getDirection(value.translation.height)
                    switch direction {
                    case .down:
                        if position == .bottom, direction.finishAnimation() {
                            show = false
                        }
                    case .up:
                        if position == .top, direction.finishAnimation() {
                            show = false
                        }
                    }
                    
                    dismissMovement = .zero
                })
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.animate = true
            }
        }
    }
    
    var updatedTextColor: Color {
        var updatedTextColor = textColor
        if checkReachability && !reachability.isConnected {
            updatedTextColor = .white
        }
        return updatedTextColor
    }
    
    var updatedText: String {
        var updatedText = text
        if checkReachability && !reachability.isConnected {
            updatedText = "Atenção\nVocê está desconectado, verifique sua conexão!"
        }
        return updatedText
    }
    
    var updatedBackgroundColor: Color {
        var updatedBackgroundColor = backgroundColor
        if checkReachability && !reachability.isConnected {
            updatedBackgroundColor = Color(.JEWDarkDefault())
        }
        return updatedBackgroundColor
    }
    
    var updatedShow: Bool {
        var updatedShow = show
        if checkReachability && !reachability.isConnected {
            updatedShow = true
        }
        return updatedShow
    }
}
