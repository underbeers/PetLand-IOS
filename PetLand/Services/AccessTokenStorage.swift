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
    func save(_ token: String)
    func restore() -> Bool
    func delete()
    
    var userID: String { get }
    func setUserID(_ id: String)
}

class AccessTokenStorage: AccessTokenStorageProtocol {
    static let shared = AccessTokenStorage()
    
    private let service = "petland"
    private let account = "accessToken"
    
    private var accessToken: String = ""
    var authHeader: HTTPHeader {
        .authorization(bearerToken: accessToken)
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
    
    func save(_ token: String) {
        let query: [CFString: AnyObject] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service as AnyObject,
            kSecAttrAccount: account as AnyObject,
            kSecValueData: token.data(using: .utf8) as AnyObject
        ]
        
        SecItemAdd(query as CFDictionary, nil)
        accessToken = token
    }
    
    func delete() {
        let query: [CFString: AnyObject] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service as AnyObject,
            kSecAttrAccount: account as AnyObject
        ]
        
        SecItemDelete(query as CFDictionary)
    }
    
    var userID: String = ""
    
    func setUserID(_ id: String) {
        userID = id
    }
}
