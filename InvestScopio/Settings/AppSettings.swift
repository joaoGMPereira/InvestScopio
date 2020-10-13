//
//  Settings.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 26/09/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import SwiftUI
import JewFeatures

enum LoggingState {
    case normal
    case admin
    case notLogged
}

class AppSettings: ObservableObject {
    @Published var loggingState = LoggingState.notLogged {
        didSet {
            if loggingState == .notLogged {
                didLogout?()
            }
        }
    }
    @Published var checkUser: Bool = (JEWKeyChainWrapper.retrieveBool(withKey: JEWConstants.LoginKeyChainConstants.hasUserLogged.rawValue) ?? false)
    @Published var tabSelection = 1 {
        didSet {
            tabSelected?(tabSelection)
        }
    }
    @Published var popup = AppPopupSettings()
    
    var tabSelected: ((Int) -> Void)?
    var didLogout: (() -> Void)?
}

class AppPopupSettings: ObservableObject {
    @Published var message: String
    @Published var textColor: Color
    @Published var backgroundColor: Color
    @Published var position: Position
    @Published var show: Bool
    
    init(message: String = String(), textColor: Color = .clear, backgroundColor: Color = .clear, position: Position = .top, show: Bool = false) {
        self.message = "Atenção!\n" + message
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.position = position
        self.show = show
    }
}
