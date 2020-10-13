//
//  AnimatedText.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 27/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI
import Charts
import ZCAnimatedLabel

struct AnimatedText: UIViewRepresentable {
    //public var data = ChartDataBase()
    var message: NSMutableAttributedString
    var size: (CGSize) -> Void
    func makeUIView(context: Context) -> ZCAnimatedLabel {
        let animatedLabel = ZCAnimatedLabel()
        animatedLabel.animationDuration = 0.3
        animatedLabel.animationDelay = 0.02
        animatedLabel.layoutTool.groupType = .char
        
        return animatedLabel
    }
    
    func updateUIView(_ uiView: ZCAnimatedLabel, context: Context) {
        if uiView.attributedString != message {
            uiView.attributedString = message
            uiView.startAppearAnimation()
            if message.string.isEmpty {
                uiView.layoutTool.clean()
            }
            size(message.string.isEmpty ? .zero : uiView.intrinsicContentSize)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject {
        
    }
}

struct AnimatedText_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedText(message: NSMutableAttributedString.init(attributedString: .titleBold(withText: "Olá futuro investidor!\n"))) { size in
            
        }
    }
}
