//
//  ImageService.swift
//  PetLand
//
//  Created by Никита Сигал on 18.05.2023.
//

import Alamofire
import Foundation

extension Endpoint {
    enum ImageService {
        static let uploadUser = Endpoint(path: "/fileUser", method: .post)
        static let uploadPet = Endpoint(path: "/filePet", method: .post)
    }
}

enum ImageServiceError: Error {}

protocol ImageServiceProtocol {
    func uploadUser(_ data: Data, _ completion: @escaping (Error?) -> ())
    func uploadPet(_ data: Data, id: Int, _ completion: @escaping (Error?) -> ())
}

final class ImageService: ImageServiceProtocol {
    static let shared = ImageService()
    private let accessTokenStorage: AccessTokenStorageProtocol = AccessTokenStorage.shared

    func uploadUser(_ data: Data, _ completion: @escaping (Error?) -> ()) {
        let endpoint = Endpoint.ImageService.uploadUser

        AF.upload(multipartFormData: { mpfd in
            mpfd.append(data, withName: "file", fileName: "file.jpg", mimeType: "image/jpeg")
            mpfd.append("\(self.accessTokenStorage.accessToken)".data(using: .utf8)!, withName: "accessToken")
        }, to: endpoint.url)
            .validate()
            .response { response in
                debugPrint(response)

                if let error = response.error {
                    switch error {
                        case .responseValidationFailed(reason: .unacceptableStatusCode(code: 500)):
                            completion(APIError.serverDown)
                        default:
                            completion(error)
                    }
                    return
                }

                completion(nil)
            }
    }

    func uploadPet(_ data: Data, id: Int, _ completion: @escaping (Error?) -> ()) {
        let endpoint = Endpoint.ImageService.uploadPet

        AF.upload(multipartFormData: { mpfd in
            mpfd.append(data, withName: "file", fileName: "file.jpeg", mimeType: "image/jpeg")
            mpfd.append("\(id)".data(using: .utf8)!, withName: "petID")
        }, to: endpoint.url)
            .validate()
            .response { response in
                debugPrint(response)

                if let error = response.error {
                    switch error {
                        case .responseValidationFailed(reason: .unacceptableStatusCode(code: 500)):
                            completion(APIError.serverDown)
                        default:
                            completion(error)
                    }
                    return
                }

                completion(nil)
            }
    }
}
