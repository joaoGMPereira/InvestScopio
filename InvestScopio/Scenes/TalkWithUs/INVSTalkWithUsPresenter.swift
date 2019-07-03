//
//  INVSSMarketPresenter.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 29/05/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import UIKit

protocol INVSTalkWithUsPresenterProtocol {
    func presentSuccessSendVote(withResponse evaluate: INVSEvaluateResponse)
    func presentError(withConnectorError connectorError: ConnectorError)
    func presentSuccessSendEmail(withFeedback feedback: String, appVersion: String)
}

class INVSTalkWithUsPresenter: NSObject,INVSTalkWithUsPresenterProtocol {
    
    weak var viewController: INVSTalkWithUsViewControllerProtocol?
    
    func presentSuccessSendVote(withResponse evaluate: INVSEvaluateResponse) {
        viewController?.displaySuccessSendVote(withTitle: INVSConstants.TalkWithUsAlertViewController.titleSuccess.rawValue, andMessage: evaluate.message)
    }
    
    func presentSuccessSendEmail(withFeedback feedback: String, appVersion: String) {
        let subject = "\(feedback) para a versão \(appVersion) do App, iOS \(UIDevice.current.systemVersion)"
        let recipients = "investscopio.s.a@gmail.com"
        let messageBody = "<p>A InvestScopio agradece seu(ua) \(feedback)!</p>"
        viewController?.displaySuccessSendEmail(withSubject: subject, recipients: recipients, andMessageBody: messageBody)
    }
    
    func presentError(withConnectorError connectorError: ConnectorError) {
        
        switch connectorError.error {
        case .none:
            viewController?.displayErrorDefault(titleError: connectorError.title, messageError: connectorError.message, shouldHideAutomatically: true, popupType: .error)
        case .authentication, .sessionExpired:
            viewController?.displayErrorAuthentication(titleError: connectorError.title, messageError: connectorError.message, shouldRetry: connectorError.shouldRetry)
        case .settings:
            viewController?.displayErrorSettings(titleError: connectorError.title, messageError: connectorError.message)
        case .logout:
            viewController?.displayErrorLogout(titleError: connectorError.title, messageError: connectorError.message)
            
        }
    }
}
