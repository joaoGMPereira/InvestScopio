//
//  Text+Extensions.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 18/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI

extension View {
    func textFont() -> some View {
        self.font(Font.system(.callout, design: .rounded).bold())
    }
}
