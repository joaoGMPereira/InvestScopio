//
//  StartView.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 23/09/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI
import Lottie

struct StartView: View {
    @EnvironmentObject var settings: AppSettings
    @ObservedObject var viewModel: StartViewModel
    @State var state = LottieState.stop
    var body: some View {
        GeometryReader { geometry in
        ZStack {
            Color("secondaryBackground")
            Color.clear
                .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8, alignment: .center)
                .overlay(Text("InvestScopio")
                            .font(.largeTitle)
                            .bold()
                            .offset(y: geometry.size.width * 0.3))
                .offset(y: -100)
            VStack {
                SUILottieView(lottieNames: LottieNames(lightName: "animatedLogo", darkName: "animatedLogoDark"), state: $state).offset(y: -100)
            }
        }
        }
        .edgesIgnoringSafeArea(.all)
        .attachEnvironmentOverrides()
        .onAppear {
            self.state = .playFrame(fromFrame: 25, toFrame: 25, loopMode: .playOnce, completion: nil)

            viewModel.authentication(completion: { isLoading in
                if isLoading {
                    self.state = .play
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.state = .stop
                    self.settings.hasUserSaved = false
                    self.settings.isLogged = true
                }
            }) { popup, hasCancelled in
                self.state = .playFrame(fromFrame: 25, toFrame: 25, loopMode: .playOnce, completion: nil)
                if hasCancelled {
                    settings.hasUserSaved = false
                }
                settings.popup = popup
            }
        }
    }
}

struct StartSU_Previews: PreviewProvider {
    static var previews: some View {
        StartView(viewModel: StartViewModel(service: StartService(webRepository: LoginWebRepository())))
    }
}
