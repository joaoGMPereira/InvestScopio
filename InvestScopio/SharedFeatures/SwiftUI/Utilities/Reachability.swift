//
//  Reachability.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 20/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import Alamofire

class Reachability: ObservableObject {
    @Published var isConnected: Bool = true
    var timerToCheck = Timer()
    
    init() {
        self.enable()
    }
    
    public func enable() {
        self.timerToCheck = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(Reachability.check), userInfo: nil, repeats: true)
        NetworkReachabilityManager()?.startListening(onQueue: DispatchQueue.main, onUpdatePerforming: { (status) in
            switch status {
            case .unknown:
                self.hasDisconnect()
            case .notReachable:
                self.hasDisconnect()
            case .reachable(_):
                self.hasConnected()
            }
        })
    }
    @discardableResult @objc public func check() -> Bool {
        if let isReachable = NetworkReachabilityManager()?.isReachable {
            isReachable ? hasConnected() : hasDisconnect()
            return isReachable
        }
        return false
    }

    func hasConnected() {
        self.isConnected = true
    }

    func hasDisconnect() {
       self.isConnected = false
    }
}
