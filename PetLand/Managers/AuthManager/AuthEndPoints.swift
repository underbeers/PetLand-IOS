//
//  AuthEndPoints.swift
//  PetLand
//
//  Created by Никита Сигал on 09.03.2023.
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
        var baseURLString: String = "http://petland-backend-k8s.raezhov.fun/api/v1"
        var path: String = "/login"
        var headers: [String: String]? = ["Content-Type": "application/json"]
        
        var encodedBody: Result<Data?, Error>
        
        init(email: String, password: String) {
            let dict = ["login": email,
                        "password": password]
            do {
                let data = try JSONEncoder().encode(dict)
                encodedBody = .success(data)
            } catch {
                encodedBody = .failure(APIService.Error.decodeError)
            }
        }
    }
    
    struct VerifyEmail: APIEndPoint {
        typealias ResponseType = APIService.EmptyResponse
        
        var httpMethod: String = "POST"
        var port: Int = 6002
        var baseURLString: String = "http://petland-backend-k8s.raezhov.fun/api/v1"
        var path: String = "/email/code"
        var headers: [String: String]? = ["Content-Type": "application/json"]
        
        var encodedBody: Result<Data?, Error>
        
        init(email: String, code: Int) {
            let dict = ["email": email,
                        "code": String(code)]
            
            do {
                let data = try JSONEncoder().encode(dict)
                encodedBody = .success(data)
            } catch {
                encodedBody = .failure(APIService.Error.decodeError)
            }
        }
    }
    
    struct Register: APIEndPoint {
        typealias ResponseType = APIService.EmptyResponse
        
        var httpMethod: String = "POST"
        var port: Int = 6002
        var baseURLString: String = "http://petland-backend-k8s.raezhov.fun/api/v1"
        var path: String = "/registration/new"
        var headers: [String: String]? = ["Content-Type": "application/json"]
        
        var encodedBody: Result<Data?, Error>
        
        init(firstName: String, lastName: String, email: String, password: String, phoneNumber: String?) {
            let dict = ["firstName": firstName,
                        "surName": lastName,
                        "email": email,
                        "mobilePhone": phoneNumber,
                        "password": password]
            
            do {
                let data = try JSONEncoder().encode(dict)
                encodedBody = .success(data)
            } catch {
                encodedBody = .failure(APIService.Error.decodeError)
            }
        }
    }
}
