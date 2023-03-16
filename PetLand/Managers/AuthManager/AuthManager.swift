//
//  AuthManager.swift
//  PetLand
//
//  Created by Никита Сигал on 31.01.2023.
//

import Foundation

protocol AuthManagerProtocol {
    func login(email: String,
               password: String,
               _ completion: @escaping (Error?) -> Void)
    func register(firstname: String,
                  lastname: String,
                  email: String,
                  password: String,
                  phoneNumber: String?,
                  _ completion: @escaping (Error?) -> Void)
    func verifyEmail(email: String,
                     code: Int,
                     _ completion: @escaping (Error?) -> Void)
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
    
    func verifyEmail(email: String, code: Int, _ completion: @escaping (Error?) -> Void) {
        APIService.EndPoints.VerifyEmail(email: email, code: code).call { result in
            switch result {
                case .success:
                    completion(nil)
                case .failure(let error):
                    completion(error)
            }
        }
    }
    
    func register(firstname: String, lastname: String, email: String, password: String, phoneNumber: String?, _ completion: @escaping (Error?) -> Void) {
        APIService.EndPoints.Register(firstName: firstname, lastName: lastname, email: email, password: password, phoneNumber: phoneNumber).call { result in
            switch result {
                case .success:
                    completion(nil)
                case .failure(let error):
                    completion(error)
            }
        }
    }
    
    func logout() {
        defaults.removeObject(forKey: "ACCESS_TOKEN")
    }
    
    var accessToken: String? {
        defaults.string(forKey: "ACCESS_TOKEN")
    }
}
