//
//  INVSCEIWorker.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 27/05/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import Alamofire
import MessageUI

typealias SuccessEmailCompletion = (_ appVersion: String) -> ()
typealias SuccessVoteCompletion = (INVSEvaluateResponse) -> ()

protocol INVSTalkWithUsWorkerProtocol {
    func sendOpinion(evaluate: Int, successCompletion: @escaping(SuccessVoteCompletion), errorCompletion:@escaping(ErrorCompletion))
    func sendEmail(successCompletion: @escaping(SuccessEmailCompletion), errorCompletion:@escaping(ErrorCompletion))
    static func getAppVersion() -> String
}

class INVSTalkWithUsWorker: NSObject,INVSTalkWithUsWorkerProtocol {
    
    func sendOpinion(evaluate: Int, successCompletion: @escaping(SuccessVoteCompletion), errorCompletion:@escaping(ErrorCompletion)) {
//        let defaultError =
//            ConnectorError.init(error: .none, title: INVSConstants.TalkWithUsAlertViewController.titleError.rawValue, message: INVSConstants.TalkWithUsAlertViewController.messageVoteError.rawValue, shouldRetry: false)
//        let version = INVSTalkWithUsWorker.getAppVersion()
//        let evaluateRequest = INVSEvaluateModel.init(rate: evaluate, version: version, versionSO: "iOS \(UIDevice.current.systemVersion)")
//        INVSConector.connector.request(withRoute: ConnectorRoutes.evaluate, method: .post, parameters: evaluateRequest, responseClass: INVSEvaluateResponse.self, headers: nil, shouldRetry: false, successCompletion: { (decodable) in
//            guard let evaluateResponse = decodable as? INVSEvaluateResponse else {
//                errorCompletion(defaultError)
//                return
//            }
//            successCompletion(evaluateResponse)
//        }) { (connectorError) in
//            errorCompletion(connectorError)
//        }
    }
    
    func sendEmail(successCompletion: @escaping(SuccessEmailCompletion), errorCompletion:@escaping(ErrorCompletion)) {
//        if MFMailComposeViewController.canSendMail() {
//            successCompletion(INVSTalkWithUsWorker.getAppVersion())
//        } else {
//            errorCompletion(ConnectorError.init(error: .none, title: INVSConstants.TalkWithUsAlertViewController.titleError.rawValue, message: INVSConstants.TalkWithUsAlertViewController.messageMailError.rawValue, shouldRetry: false))
//        }
    }
    
    static func getAppVersion() -> String {
//        if let nsObject: AnyObject = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject? {
//            if let version = nsObject as? String {
//                 return version
//            }
//        }
        return ""
    }
}
