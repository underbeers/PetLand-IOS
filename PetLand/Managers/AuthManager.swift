//
//  AuthManager.swift
//  PetLand
//
//  Created by Никита Сигал on 31.01.2023.
//

import Foundation

extension APIService.EndPoints {
    struct Login: APIEndPoint {
        struct Response: APIResponse {
            static var shouldExist: Bool = true
            
            var accessToken: String
        }
        
        typealias ResponseType = Response
        
        var httpMethod: String = "POST"
        var port: Int = 6002
        var baseURLString: String = "http://79.137.198.139:6002/api/v1"
        var path: String = "/login/"
        var headers: [String: String]? = ["Content-Type": "application/json"]
        
        var body: [String: String]?
        
        init(email: String, password: String) {
            body = ["login": email,
                    "password": password]
        }
    }
}

protocol AuthManagerProtocol {
    func login(email: String, password: String, _ completion: @escaping (Error?) -> Void)
    func register(firstname: String, lastname: String,
                  email: String, password: String,
                  phoneNumber: String?)
    func logout()
    var accessToken: String? { get }
}

class AuthManager: AuthManagerProtocol {
    static let shared = AuthManager()
    
    private let defaults = UserDefaults.standard
    
    func login(email: String, password: String, _ completion: @escaping (Error?) -> Void) {
        APIService.EndPoints.Login(email: email, password: password).call { [weak self] result in
            switch result {
                case .success(let data):
                    self?.defaults.setValue(data!.accessToken, forKey: "ACCESS_TOKEN")
                    completion(nil)
                case .failure(let error):
                    completion(error)
            }
        }
    }
    
    func register(firstname: String, lastname: String, email: String, password: String, phoneNumber: String?) {}
    
    func logout() {
        defaults.removeObject(forKey: "ACCESS_TOKEN")
    }
    
    var accessToken: String? {
        defaults.string(forKey: "ACCESS_TOKEN")
    }
}
