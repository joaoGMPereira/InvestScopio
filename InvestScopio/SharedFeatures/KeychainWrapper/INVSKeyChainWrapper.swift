//
//  KeychainWrapper.swift
//  InvestScopio_Example
//
//  Created by Joao Medeiros Pereira on 14/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class INVSKeyChainWrapper: NSObject {
    static let uniqueServiceName = "com.br.joao.gabriel.medeiros.pereira.InvestScopio"
    static let instance : KeychainWrapper = {
        return KeychainWrapper(serviceName: uniqueServiceName)
    }()
    
    static func save(withValue value:String, andKey key: String) -> Bool {
        let saveSuccessful: Bool = INVSKeyChainWrapper.instance.set(value, forKey: key)
        return saveSuccessful
    }
    
    static func update(withValue value:String, andKey key: String) -> Bool {
        let _: Bool = INVSKeyChainWrapper.instance.removeObject(forKey: key)
        let updateSuccessful: Bool = INVSKeyChainWrapper.instance.set(value, forKey: key)
        return updateSuccessful
    }
    
    static func retrieve(withKey key: String) -> String? {
        let retrievedString: String? = INVSKeyChainWrapper.instance.string(forKey: key)
        return retrievedString
    }
    
    static func saveDouble(withValue value:Double, andKey key: String) -> Bool {
        let saveSuccessful: Bool = INVSKeyChainWrapper.instance.set(value, forKey: key)
        return saveSuccessful
    }
    
    static func updateDouble(withValue value:Double, andKey key: String) -> Bool {
        let _: Bool = INVSKeyChainWrapper.instance.removeObject(forKey: key)
        let updateSuccessful: Bool = INVSKeyChainWrapper.instance.set(value, forKey: key)
        return updateSuccessful
    }
    
    static func retrieveDouble(withKey key: String) -> Double? {
        let retrievedInt: Double? = INVSKeyChainWrapper.instance.double(forKey: key)
        return retrievedInt
    }
    
    //MARK: Remove any kind of object
    static func remove(withKey key: String) -> Bool {
        let removeSuccessful: Bool = INVSKeyChainWrapper.instance.removeObject(forKey: key)
        return removeSuccessful
    }
    
    static func clear() {
        INVSKeyChainWrapper.instance.removeAllKeys()
       
    }
}
