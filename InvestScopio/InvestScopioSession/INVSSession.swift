//
//  InvestScopioSession.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 29/05/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation

final class INVSSession {
    
    // Can't init is singleton
    private init() { }

    static let session = INVSSession()
    var market: MarketModel?


    
}
