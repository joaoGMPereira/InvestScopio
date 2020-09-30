//
//  AppConfig.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 29/09/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import JewFeatures

enum Configuration {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }

    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey:key) else {
            throw Error.missingKey
        }

        if let string = object as? String, let generic = T(string.replacingOccurrences(of: "\"", with: "")) {
            return generic
        }
        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}

enum Scheme:String {
    case Debug
    case Release
    static var scheme: Scheme {
        do {
            return try Scheme.init(rawValue: Configuration.value(for: "APPScheme")) ?? .Release
        } catch {
            return .Release
        }
    }
    
    static func setupConfig() {
        setUniqueServiceName()
        setBaseURL()
    }
    
    static func setUniqueServiceName() {
        do {
            JEWKeyChainWrapperServiceName.instance.uniqueServiceName = try Configuration.value(for: "CFBundleIdentifier")
        } catch {
            JEWKeyChainWrapperServiceName.instance.uniqueServiceName = "com.br.joao.gabriel.medeiros.pereira.InvestScopio"
        }
    }
    
    static func setBaseURL() {
        var baseURL = AppConstants.ServicesConstants.apiV1.rawValue
        if Scheme.scheme == .Debug {
            baseURL = JEWSession.session.services.callService == .heroku ? AppConstants.ServicesConstants.apiV1Dev.rawValue : JEWConstants.Services.localHost.rawValue
        }
        JEWConnector.connector.baseURL = baseURL
    }
}
