//
//  AccessTokenStorage.swift
//  PetLand
//
//  Created by Никита Сигал on 05.05.2023.
//
//  https://www.youtube.com/watch?v=cQjgBIJtMbw

import Alamofire
import Foundation

protocol AccessTokenStorageProtocol {
    var authHeader: HTTPHeader { get }
    var accessToken: String { get }
    var userID: String { get }
    
    func save(_ token: String, stayLoggedIn: Bool)
    func restore() -> Bool
    func delete()
    func setUserID(_ id: String)
}

class AccessTokenStorage: AccessTokenStorageProtocol {
    static let shared = AccessTokenStorage()
    
    private let service = "petland"
    private let account = "accessToken"

    var accessToken: String = ""
    var userID: String = ""
    var authHeader: HTTPHeader {
        .authorization(bearerToken: accessToken)
    }
    
    func setUserID(_ id: String) {
        userID = id
    }
    
    func restore() -> Bool {
        let query: [CFString: AnyObject] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service as AnyObject,
            kSecAttrAccount: account as AnyObject,
            kSecReturnData: kCFBooleanTrue,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        
        accessToken = String(data: result as? Data ?? Data(), encoding: .utf8)!
        return !accessToken.isEmpty
    }
    
    func save(_ token: String, stayLoggedIn: Bool) {
        accessToken = token
        
        if stayLoggedIn {
            let query: [CFString: AnyObject] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service as AnyObject,
                kSecAttrAccount: account as AnyObject,
                kSecValueData: token.data(using: .utf8) as AnyObject
            ]
            
            SecItemAdd(query as CFDictionary, nil)
        }
    }
    
    func delete() {
        let query: [CFString: AnyObject] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service as AnyObject,
            kSecAttrAccount: account as AnyObject
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
