//
//  INVSSMarketInteractor.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 29/05/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import UIKit

protocol INVSTalkWithUsInteractorProtocol {
    func sendEmail(withFeedback feedback: String)
    func sendOpinion()
    var evaluate: Int? { get set }
}

class INVSTalkWithUsInteractor: NSObject, INVSTalkWithUsInteractorProtocol {
    var evaluate: Int?
    var presenter: INVSTalkWithUsPresenterProtocol?
    var worker: INVSTalkWithUsWorkerProtocol = INVSTalkWithUsWorker()
    
    func sendOpinion() {
        guard let evaluate = evaluate else {
//            self.presenter?.presentError(withConnectorError: ConnectorError.init(error: .none, title: INVSConstants.TalkWithUsAlertViewController.titleError.rawValue, message: INVSConstants.TalkWithUsAlertViewController.messageInvalidVoteError.rawValue, shouldRetry: false))
            return
        }
        worker.sendOpinion(evaluate: evaluate, successCompletion: { evaluateResponse in
            self.presenter?.presentSuccessSendVote(withResponse: evaluateResponse)
        }) { (connectorError) in
           // self.presenter?.presentError(withConnectorError: connectorError)
        }
    }
    
    func sendEmail(withFeedback feedback: String) {
        worker.sendEmail(successCompletion: { appVersion in
            self.presenter?.presentSuccessSendEmail(withFeedback: feedback, appVersion: appVersion)
        }) { (connectorError) in
       //     self.presenter?.presentError(withConnectorError: connectorError)
        }
    }
    
//    func hasEvaluatedVersion() -> Bool {
//        let email = INVSKeyChainWrapper.retrieve(withKey: INVSConstants.LoginKeyChainConstants.lastLoginEmail.rawValue)
//        if let emailRetrived = email {
//            
//            INVSKeyChainWrapper.save(withValue: "\(emailRetrived)\(worker.getAppVersion())", andKey: INVSConstants.LoginKeyChainConstants.hasEvaluateApp.rawValue)
//        }
//    }
}
