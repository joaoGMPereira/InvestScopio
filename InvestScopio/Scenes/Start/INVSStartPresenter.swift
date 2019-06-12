//
//  INVSSMarketPresenter.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 29/05/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation

protocol INVSStartPresenterProtocol {
    func presentMarketInfo(withMarket market: MarketModel)
    func presentMarketError(withMarketError error: String)
    
}

class INVSStartPresenter: NSObject,INVSStartPresenterProtocol {
    
    weak var controller: INVSStartViewController?
    
    func presentMarketInfo(withMarket market: MarketModel) {
        INVSSession.session.market = market
        self.controller?.displayMarketInfo(withMarketInfo: market)
    }
    
    func presentMarketError(withMarketError error: String) {
        self.controller?.displayMarketInfoError(witMarketError: error)
    }
    
    
}
