//
//  INVSBiometrics.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 21/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import LocalAuthentication

public typealias AuthenticationSuccess = (() -> ())
public typealias AuthenticationFailure = ((AuthenticationError) -> ())

let kBiometryNotAvailableReason = "Autenticação de biometria não está disponível neste iPhone."

enum BioMetricsTouchIDErrors: String {
    //Touch ID
    case kTouchIdAuthenticationReason = "Confirme sua digital para autenticar."
    case kTouchIdPasscodeAuthenticationReason = "Touch ID está bloqueado agora, porque muitas tentativas falharam. Digite sua senha para desbloquear o Touch ID."
    
    /// Error Messages Touch ID
    case kSetPasscodeToUseTouchID = "Por favor digite sua senha para usar Touche ID para autenticação."
    case kNoFingerprintEnrolled = "Não tem nenhuma digital cadastrada no iPhone. Por favor vá para: Ajustes -> Touch ID & Código e cadastre suas digitais."
    case kDefaultTouchIDAuthenticationFailedReason = "O Touch ID não reconhece a sua digital. Por favor tente novamente com a sua digital cadastrada."
    case kDefaultTouchIDErrorAuthentication = "Não foi possível autenticar seu Touch ID."
    
}

enum BioMetricsFaceIDErrors: String{
    //Face ID
    case kFaceIdAuthenticationReason = "Confirme sua face para autenticar."
    case kFaceIdPasscodeAuthenticationReason = "Face ID está bloqueado agora, porque muitas tentativas falharam. Digite sua senha para desbloquear o Face ID."
    
    // Error Messages Face ID
    case kSetPasscodeToUseFaceID = "Por favor digite sua senha para usar Face ID para autenticação."
    case kNoFaceIdentityEnrolled = "Não tem nenhuma face cadastrada no iPhone. Por favor vá para: Ajustes -> Face ID & Código e cadastre sua face."
    case kDefaultFaceIDAuthenticationFailedReason = "O Face ID não reconhece a sua face. Por favor tente novamente com a sua face cadastrada."
    case kDefaultFaceIDErrorAuthentication = "Não foi possível autenticar seu Face ID."
}


public enum AuthenticationError {
    
    case failed, canceledByUser, fallback, canceledBySystem, passcodeNotSet, biometryNotAvailable, biometryNotEnrolled, biometryLockedout, other
    
    public static func initWithError(_ error: LAError) -> AuthenticationError {
        switch Int32(error.errorCode) {
            
        case kLAErrorAuthenticationFailed:
            return failed
        case kLAErrorUserCancel:
            return canceledByUser
        case kLAErrorUserFallback:
            return fallback
        case kLAErrorSystemCancel:
            return canceledBySystem
        case kLAErrorPasscodeNotSet:
            return passcodeNotSet
        case kLAErrorBiometryNotAvailable:
            return biometryNotAvailable
        case kLAErrorBiometryNotEnrolled:
            return biometryNotEnrolled
        case kLAErrorBiometryLockout:
            return biometryLockedout
        default:
            return other
        }
    }
    
    // get error message based on type
    public func message() -> String {
        let authentication = INVSBiometrics.shared
        
        switch self {
        case .canceledByUser, .fallback, .canceledBySystem:
            return "Tente novamente mais tarde."
        case .passcodeNotSet:
            return authentication.faceIDAvailable() ? BioMetricsFaceIDErrors.kSetPasscodeToUseFaceID.rawValue : BioMetricsTouchIDErrors.kSetPasscodeToUseTouchID.rawValue
        case .biometryNotAvailable:
            return kBiometryNotAvailableReason
        case .biometryNotEnrolled:
            return authentication.faceIDAvailable() ? BioMetricsFaceIDErrors.kNoFaceIdentityEnrolled.rawValue : BioMetricsTouchIDErrors.kNoFingerprintEnrolled.rawValue
        case .biometryLockedout:
            return authentication.faceIDAvailable() ? BioMetricsFaceIDErrors.kFaceIdPasscodeAuthenticationReason.rawValue : BioMetricsTouchIDErrors.kTouchIdPasscodeAuthenticationReason.rawValue
        default:
            return authentication.faceIDAvailable() ? BioMetricsFaceIDErrors.kDefaultFaceIDAuthenticationFailedReason.rawValue : BioMetricsTouchIDErrors.kDefaultTouchIDAuthenticationFailedReason.rawValue
        }
    }
    
    public func shouldRetry() -> Bool {
        switch self {
        case .canceledByUser, .fallback, .canceledBySystem, .passcodeNotSet, .biometryNotAvailable, .biometryNotEnrolled, .biometryLockedout:
            return false
        default:
            return true
        }
    }
}

class INVSBiometrics: NSObject {
    public static let shared = INVSBiometrics()
    
    class func canAuthenticate() -> Bool {
        
        var isBioMetrixAuthenticationAvailable = false
        var error: NSError? = nil
        
        if LAContext().canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            isBioMetrixAuthenticationAvailable = (error == nil)
        }
        return isBioMetrixAuthenticationAvailable
    }
    
    class func authenticateWithBiometrics(reason: String, fallbackTitle: String? = "", cancelTitle: String? = "", success successBlock:@escaping AuthenticationSuccess, failure failureBlock:@escaping AuthenticationFailure) {
        let reasonString = reason.isEmpty ? INVSBiometrics.shared.defaultBiometricsAuthenticationReason() : reason
        
        let context = LAContext()
        context.localizedFallbackTitle = fallbackTitle
        
        // cancel button title
        if #available(iOS 10.0, *) {
            context.localizedCancelTitle = cancelTitle
        }
        
        // authenticate
        INVSBiometrics.shared.evaluate(policy: LAPolicy.deviceOwnerAuthenticationWithBiometrics, with: context, reason: reasonString, success: successBlock, failure: failureBlock)
    }
    
    class func authenticateWithPasscode(reason: String, cancelTitle: String? = "", success successBlock:@escaping AuthenticationSuccess, failure failureBlock:@escaping AuthenticationFailure) {
        let reasonString = reason.isEmpty ? INVSBiometrics.shared.defaultPasscodeAuthenticationReason() : reason
        
        let context = LAContext()
        context.localizedCancelTitle = cancelTitle
        
        // authenticate
        INVSBiometrics.shared.evaluate(policy: LAPolicy.deviceOwnerAuthentication, with: context, reason: reasonString, success: successBlock, failure: failureBlock)
    }
    
    public func faceIDAvailable() -> Bool {
        let context = LAContext()
        return (context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: nil) && context.biometryType == .faceID)
    }
    
    func defaultBiometricsAuthenticationReason() -> String {
        return faceIDAvailable() ? BioMetricsFaceIDErrors.kFaceIdAuthenticationReason.rawValue : BioMetricsTouchIDErrors.kTouchIdAuthenticationReason.rawValue
    }
    
    func defaultPasscodeAuthenticationReason() -> String {
        return faceIDAvailable() ? BioMetricsFaceIDErrors.kFaceIdPasscodeAuthenticationReason.rawValue : BioMetricsTouchIDErrors.kTouchIdPasscodeAuthenticationReason.rawValue
    }
    
    func evaluate(policy: LAPolicy, with context: LAContext, reason: String, success successBlock:@escaping AuthenticationSuccess, failure failureBlock:@escaping AuthenticationFailure) {
        
        context.evaluatePolicy(policy, localizedReason: reason) { (success, err) in
            DispatchQueue.main.async {
                if success { successBlock() }
                else {
                    let errorType = AuthenticationError.initWithError(err as! LAError)
                    failureBlock(errorType)
                }
            }
        }
    }
}
