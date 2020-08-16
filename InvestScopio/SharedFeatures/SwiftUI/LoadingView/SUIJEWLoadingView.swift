//
//  SUIJEWLoadingView.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 19/01/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import SwiftUI


struct SUIJEWLoadingView: View {
@State var inStart: Bool = true
@State var childSize: CGSize = .zero
var body: some View {
    ZStack {
        GeometryReader.init { proxy in
            Rectangle().frame(width: proxy.size.width, height: proxy.size.height).foregroundColor((Color.init(red: 230/255, green: 230/255, blue: 230/255)))
            Rectangle().frame(width: proxy.size.width/4, height: proxy.size.height).foregroundColor(.clear).background(BackgroundGeometry())
                .position(x: self.helloH(proxy: proxy), y: proxy.size.height/2).onPreferenceChange(SizePreferenceKey.self, perform: {
                    self.childSize = $0
                    self.moveToRight()
                }).animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: false))
        }
    }
}
    
    func moveToRight() {
        withAnimation {
            self.inStart = false
        }
    }
    
    func helloH(proxy: GeometryProxy) -> CGFloat {
        if inStart {
            return -childSize.width/2
        }
        return proxy.size.width + childSize.width/2
    }
    
}

struct BackgroundGeometry: View {
    static let backgroundColor = Color.init(red: 200/255, green: 200/255, blue: 200/255)
    static let backgroundMeioColor = Color.init(red: 100/255, green: 200/255, blue: 200/255)
    static let background01Color = backgroundColor.opacity(0.4)
    static let background02Color = backgroundColor.opacity(0.5)
    static let background03Color = backgroundColor.opacity(0.6)
    static let background04Color = backgroundColor.opacity(0.7)
    static let background05Color = backgroundColor.opacity(0.9)
    
    static let colors = Gradient(colors: gradientColors())
    let conic = LinearGradient(gradient: colors, startPoint: .leading, endPoint: .trailing)
    
    var body: some View {
        GeometryReader { geometry in
            return Rectangle().fill(self.conic).opacity(0.6).preference(key: SizePreferenceKey.self, value: geometry.size)
        }.clipped()
    }
    
    static func gradientColors() -> [Color] {
        var gradientColors = [Color]()
        var opacityColor: Double = 0
        
        while opacityColor < 0.9 {
            let gradientColor = backgroundColor.opacity(opacityColor)
            gradientColors.append(gradientColor)
            opacityColor += 0.05
        }
        while opacityColor > 0 {
            let gradientColor = backgroundColor.opacity(opacityColor)
            gradientColors.append(gradientColor)
            opacityColor -= 0.05
        }
        return gradientColors
    }
}



struct SUIJEWLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        SUIJEWLoadingView()
    }
}

