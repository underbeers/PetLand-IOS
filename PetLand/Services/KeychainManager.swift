//
//  KeychainManager.swift
//  PetLand
//
//  Created by Никита Сигал on 05.05.2023.
//
//  https://www.youtube.com/watch?v=cQjgBIJtMbw

import Foundation

class KeychainManager {
    enum KeychainError: Error {
        case duplicateItem,
             unknown(OSStatus)
    }
    
    static func save(service: String, account: String, data: Data) {
        let query: [CFString: AnyObject] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service as AnyObject,
            kSecAttrAccount: account as AnyObject,
            kSecValueData: data as AnyObject
        ]
        
        SecItemAdd(query as CFDictionary, nil)
    }
    
    static func get(service: String, account: String) -> Data? {
        let query: [CFString: AnyObject] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service as AnyObject,
            kSecAttrAccount: account as AnyObject,
            kSecReturnData: kCFBooleanTrue,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        
        return result as? Data
    }
    
    static func delete(service: String, account: String) {
        let query: [CFString: AnyObject] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service as AnyObject,
            kSecAttrAccount: account as AnyObject
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
