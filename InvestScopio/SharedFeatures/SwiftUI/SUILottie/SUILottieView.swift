//
//  LottieView.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 01/01/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import Foundation
import SwiftUI
import Lottie

struct SUILottieView: UIViewRepresentable {
    
    let animationView = AnimationView()
    var lottieNames: LottieNames
    var loopMode: LottieLoopMode = .loop
    var contentMode: UIView.ContentMode = .scaleAspectFill
    @Binding var state: LottieState
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    func makeUIView(context: UIViewRepresentableContext<SUILottieView>) -> UIView {
        let view = UIView()
        let loadAnimation = Animation.named(lottieNames.getName(colorScheme: colorScheme), bundle: Bundle.main)
        animationView.animation = loadAnimation
        animationView.contentMode = contentMode
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.animationSpeed = 1.0
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        return view
    }
    
    func startAnimation() {
        
    }
    
    func startAnimation(fromFrame: CGFloat, toFrame: CGFloat, loopMode: LottieLoopMode, completion: LottieCompletionBlock?) {
        animationView.play(fromFrame: fromFrame, toFrame: toFrame, loopMode: loopMode, completion: completion)
    }
    
    func stopAnimation() {
        animationView.stop()
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SUILottieView>) {
        let updateAnimation = Animation.named(lottieNames.getName(colorScheme: colorScheme), bundle: Bundle.main)
        if let lottieView = uiView.subviews.first as? AnimationView {
            lottieView.animation = updateAnimation
            switch state {
            case .play:
                lottieView.loopMode = loopMode
                lottieView.play()
            case .playFrame(fromFrame: let fromFrame, toFrame: let toFrame, loopMode: let loopMode, completion: let completion):
                lottieView.loopMode = loopMode
                lottieView.play(fromFrame: fromFrame, toFrame: toFrame, loopMode: loopMode, completion: completion)
            case .stop:
                lottieView.stop()
            }
        }
    }
}

enum LottieState {
    case play
    case playFrame(fromFrame: CGFloat, toFrame: CGFloat, loopMode: LottieLoopMode, completion: LottieCompletionBlock?)
    case stop
}

struct LottieNames {
    let lightName: String
    let darkName: String
    
    func getName(colorScheme: ColorScheme) -> String {
        if colorScheme == .dark {
            return darkName
        }
        return lightName
    }
}

