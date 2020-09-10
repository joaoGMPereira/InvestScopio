//
//  SplitView.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 29/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI

enum SplitViewDirection {
    case down(_ translation: CGFloat)
    case up(_ translation: CGFloat)
    
    static func getDirection(_ translation: CGFloat) -> SplitViewDirection {
        return translation > 0 ? .down(translation) : .up(translation)
    }
    
    func finishAnimation() -> Bool {
        switch self {
        case .down(let translation):
            return translation > 150
        case .up(let translation):
            return translation < -150
        }
    }
}

struct SplitView<Content: View>: View {
    let content: () -> Content
    var minHeight: CGFloat
    var forceCloseWhenDisappear: Bool
    @State private var updatedHeight: CGFloat
    @Binding private var isOpened: Bool
    
    public init(isOpened: Binding<Bool>, minHeight: CGFloat = 66, forceCloseWhenDisappear: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self._isOpened = isOpened
        self.minHeight = minHeight
        self.forceCloseWhenDisappear = forceCloseWhenDisappear
        self.content = content
        self._updatedHeight = .init(initialValue: minHeight)
        
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Color("secondaryBackground").overlay(self.content()).cornerRadius(8, corners: [.topLeft, .topRight]).shadow(color: Color("accessoryBackground").opacity(0.8), radius: 8).frame(height: self.updatedHeight).animation(.easeInOut)
            }
            .gesture(
                DragGesture()
                    .onChanged({ (value) in
                        let contentViewHeight = geometry.frame(in: .global).height
                        var calculatedState: CGFloat = self.isOpened ? contentViewHeight : self.minHeight
                        calculatedState -= value.translation.height
                        
                        if calculatedState < self.minHeight {
                            calculatedState = self.minHeight
                        }
                        if calculatedState > contentViewHeight {
                            calculatedState = contentViewHeight
                        }
                        let direction = SplitViewDirection.getDirection(value.translation.height)
                    
                        switch direction {
                        case .down:
                            if direction.finishAnimation() {
                                calculatedState = self.minHeight
                            }
                        case .up:
                            if direction.finishAnimation() {
                                calculatedState = contentViewHeight
                            }
                        }
                        
                        self.updatedHeight = calculatedState
                    })
                    .onEnded({ (value) in
                        let contentViewHeight = geometry.frame(in: .global).height
                        if self.updatedHeight > contentViewHeight/2 {
                            self.updatedHeight = contentViewHeight
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.isOpened = true
                            }
                        } else {
                            self.updatedHeight = self.minHeight
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.isOpened = false
                            }
                        }
                    })
            )
        }.onDisappear {
            if self.forceCloseWhenDisappear {
                self.isOpened = false
                self.updatedHeight = self.minHeight
            }
        }
    }
}
