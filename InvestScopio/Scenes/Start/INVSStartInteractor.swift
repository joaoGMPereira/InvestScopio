//
//  INVSSMarketInteractor.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 29/05/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import UIKit
protocol INVSStartInteractorProtocol {
    func downloadMarketInfo()
}

class INVSStartInteractor: NSObject, INVSStartInteractorProtocol {
    
    var presenter: INVSStartPresenterProtocol?
    var worker: INVSStartWorkerProtocol = INVSStartWorker()
    
    func downloadMarketInfo() {
        worker.downloadMarketInfo(successCompletionHandler: { (market) in
            self.presenter?.presentMarketInfo(withMarket: market)
        }) { (error) in
            self.presenter?.presentMarketError(withMarketError: error)
        }
    }
}
