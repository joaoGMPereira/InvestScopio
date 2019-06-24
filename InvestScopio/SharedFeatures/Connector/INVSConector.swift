//
//  Connector.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 05/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import Alamofire
typealias SuccessResponse = (Decodable) -> ()
typealias SuccessVoidResponse = () -> ()
typealias SuccessRefreshResponse = (_ shouldUpdateHeaders: Bool) -> ()
typealias ErrorResponse = (DefaultError) -> ()

final class INVSConector {
    
    // Can't init is singleton
    private init() { }
    
    static let connector = INVSConector()
    let workerLogin: INVSLoginWorkerProtocol = INVSLoginWorker()
    
    static func getURL(withRoute route: String) -> URL? {
        var baseURL = URL(string: "\(INVSConstants.INVSServicesConstants.apiV1.rawValue)\(route)")
        if INVSSession.session.isDev() {
            baseURL = INVSSession.session.callService == .heroku ? URL(string: "\(INVSConstants.INVSServicesConstants.apiV1Dev.rawValue)\(route)") : URL(string: "\(INVSConstants.INVSServicesConstants.localHost.rawValue)\(route)")
        }
        return baseURL
    }
    
    static func getVersion() -> URL? {
        return getURL(withRoute: INVSConstants.INVSServicesConstants.version.rawValue)
    }
    
    func request<T: Decodable>(withRoute route: ConnectorRoutes, method: HTTPMethod = .get, parameters: JSONAble? = nil, responseClass: T.Type, headers: HTTPHeaders? = nil, shouldRetry: Bool = false, lastViewController: UIViewController? = nil, successCompletion: @escaping(SuccessResponse), errorCompletion: @escaping(ErrorResponse)) {
        
        guard let url = route.getRoute() else {
            return
        }
        
        refreshToken(withRoute: route, lastViewController: lastViewController, successCompletion: { (shouldUpdateHeaders) in
            var headersUpdated = headers
            if shouldUpdateHeaders {
                guard let headersWithAccessToken = ["Content-Type": "application/json", "Authorization": INVSSession.session.user?.access?.accessToken] as? HTTPHeaders else {
                    errorCompletion(DefaultError.default())
                    return
                }
                headersUpdated = headersWithAccessToken
            }
            self.requestBlock(withURL: url, method: method, parameters: parameters, responseClass: responseClass, headers: headersUpdated, successCompletion: { (decodable) in
                successCompletion(decodable)
            }) { (error) in
                if shouldRetry && error.error {
                    self.request(withRoute: route, method: method, parameters: parameters, responseClass: responseClass, headers: headers, shouldRetry: false, successCompletion: successCompletion, errorCompletion: errorCompletion)
                    return
                }
                errorCompletion(error)
            }
        }) { (error) in
            errorCompletion(error)
        }
    }
    
    private func requestBlock<T: Decodable>(withURL url: URL, method: HTTPMethod = .get, parameters: JSONAble? = nil, responseClass: T.Type, headers: HTTPHeaders? = nil, successCompletion: @escaping(SuccessResponse), errorCompletion: @escaping(ErrorResponse)) {
        Alamofire.request(url, method: method, parameters: parameters?.toDict(), encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            let responseResult = response.result
            if responseResult.error != nil {
                do {
                    if let data = response.data {
                        var defaultError = try JSONDecoder().decode(DefaultError.self, from: data)
                        defaultError.error = false
                        errorCompletion(defaultError)
                    } else {
                        errorCompletion(ConnectorError.checkErrorCode(.parseError))
                    }
                    return
                }
                catch {
                    errorCompletion(ConnectorError.checkErrorCode(.parseError))
                    return
                }
                
            }
            switch responseResult {
            case .success:
                do {
                    if let data = response.data {
                        let decodable = try JSONDecoder().decode(T.self, from: data)
                        successCompletion(decodable)
                    } else {
                        errorCompletion(ConnectorError.checkErrorCode(.parseError))
                    }
                    break
                }
                catch {
                    errorCompletion(ConnectorError.checkErrorCode(.parseError))
                    break
                }
            case .failure:
                errorCompletion(DefaultError.default())
                break
            }
        }
    }
    
    private func refreshToken(withRoute route:ConnectorRoutes, lastViewController: UIViewController? = nil, successCompletion: @escaping(SuccessRefreshResponse), errorCompletion: @escaping(ErrorResponse)) {
        if route != .signup &&  route != .signin &&  route != .logout {
            guard let url = ConnectorRoutes.refreshToken.getRoute() else {
                errorCompletion(DefaultError.init(error: true, reason: "URL Inválida!"))
                return
            }
            guard let refreshToken = INVSSession.session.user?.access?.refreshToken else {
                errorCompletion(DefaultError.init(error: true, reason: "Refresh Token Inválido!"))
                return
            }
            guard let headers = ["Content-Type": "application/json", "Authorization": INVSSession.session.user?.access?.accessToken] as? HTTPHeaders else {
                errorCompletion(DefaultError.init(error: true, reason: "Access Token Inválido!"))
                return
            }
            let refreshTokenRequest = INVSRefreshTokenRequest.init(refreshToken: refreshToken)
            requestBlock(withURL: url, method: .post, parameters: refreshTokenRequest, responseClass: INVSAccessModel.self, headers: headers, successCompletion: { (decodable) in
                let accessModel = decodable as? INVSAccessModel
                INVSSession.session.user?.access = accessModel
                successCompletion(true)
            }) { (error) in
                self.checkLoggedUser(lastViewController: lastViewController) {
                    successCompletion(true)
                }
            }
        } else {
            successCompletion(false)
        }
    }
    
    
    func checkLoggedUser(lastViewController: UIViewController? = nil, successCompletion: @escaping(SuccessVoidResponse)) {
        let hasBiometricAuthenticationEnabled = INVSKeyChainWrapper.retrieveBool(withKey: INVSConstants.LoginKeyChainConstants.hasEnableBiometricAuthentication.rawValue)
        guard let hasBiometricAuthentication = hasBiometricAuthenticationEnabled, hasBiometricAuthentication == true else {
            INVSConnectorHelpers.presentErrorRememberedUserLogged(lastViewController: lastViewController, error: AuthenticationError.sessionExpired) {}
            return
        }
        INVSBiometricsChallenge.checkLoggedUser(reason: "Sessão expirada!\nAutentique novamente para continuar." ,successChallenge: {
            self.loginUserSaved {
                successCompletion()
            }
        }) { (challengeFailureType) in
            switch challengeFailureType {
            case .default:
                INVSConnectorHelpers.presentErrorRememberedUserLogged(lastViewController: lastViewController)
                break
            case .error(let error):
                INVSConnectorHelpers.presentErrorRememberedUserLogged(lastViewController: lastViewController, error: error, successCompletion: {
                    successCompletion()
                })
                break
            case .goSettings(let error):
               INVSConnectorHelpers.presentErrorGoToSettingsRememberedUserLogged(lastViewController: lastViewController, message: error.message())
                break
            }
        }
    }
    
    private func loginUserSaved(successCompletion: @escaping(SuccessVoidResponse)) {
        let email = INVSKeyChainWrapper.retrieve(withKey: INVSConstants.LoginKeyChainConstants.lastLoginEmail.rawValue)
        let security = INVSKeyChainWrapper.retrieve(withKey: INVSConstants.LoginKeyChainConstants.lastLoginSecurity.rawValue)
        if let emailRetrived = email, let securityRetrived = security {
            if let emailAES = INVSCrypto.decryptAES(withText: emailRetrived), let securityAES = INVSCrypto.decryptAES(withText: securityRetrived) {
                workerLogin.loggedUser(withEmail: emailAES, security: securityAES, successCompletionHandler: { (userResponse) in
                    INVSSession.session.user = userResponse
                    successCompletion()
                }) { (title, message, shouldHideAutomatically, popupType) in
                    INVSKeyChainWrapper.clear()
                    INVSConnectorHelpers.presentErrorRememberedUserLogged()
                }
            } else {
                INVSKeyChainWrapper.clear()
                INVSConnectorHelpers.presentErrorRememberedUserLogged()
            }
        } else {
            INVSKeyChainWrapper.clear()
            INVSConnectorHelpers.presentErrorRememberedUserLogged()
        }
    }
    
    
}
