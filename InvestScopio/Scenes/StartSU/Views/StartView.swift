//
//  StartView.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 23/09/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI
import Lottie
import JewFeatures
struct StartView: View {
    @EnvironmentObject var settings: AppSettings
    @ObservedObject var viewModel: StartViewModel
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
                    
                    SUILottieView(lottieNames: LottieNames(lightName: "animatedLogo", darkName: "animatedLogoDark"), state: $viewModel.state).offset(y: -100)
                        .overlay(SchemeView {
                            viewModel.authentication(completion: {
                                self.settings.checkUser = false
                                self.settings.loggingState = .normal
                                settings.popup = AppPopupSettings()
                            }) { popup, hasCancelled in
                                if hasCancelled {
                                    settings.checkUser = false
                                }
                                settings.popup = popup
                            }
                        }.offset(y: 100))
                    
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .attachEnvironmentOverrides()
        .onAppear {
            if JEWSession.session.services.scheme == .Release {
                viewModel.authentication(completion: {
                    self.settings.checkUser = false
                    self.settings.loggingState = .normal
                    settings.popup = AppPopupSettings()
                }) { popup, hasCancelled in
                    if hasCancelled {
                        settings.checkUser = false
                    }
                    settings.popup = popup
                }
            } else {
                self.viewModel.state = .playFrame(fromFrame: 25, toFrame: 25, loopMode: .playOnce, completion: nil)
            }
        }
    }
}

struct StartSU_Previews: PreviewProvider {
    static var previews: some View {
        StartView(viewModel: StartViewModel(service: StartService(webRepository: LoginWebRepository())))
    }
}
