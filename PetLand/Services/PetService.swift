//
//  PetService.swift
//  PetLand
//
//  Created by Никита Сигал on 07.05.2023.
//

import Alamofire
import Foundation

extension Endpoint {
    enum PetService {
        static let getPetInfoGeneral = Endpoint(path: "/petCards/main", method: .get)
    }
}

enum PetServiceError: Error {}

protocol PetServiceProtocol {
    func getPetInfoGeneral(petID: String?, userID: String?, petTypeID: String?, breedID: String?, gender: String?, completion: @escaping (Result<[Pet], Error>) -> ())
}

final class PetService: PetServiceProtocol {
    static let shared = PetService()

    private let accessTokenStorage: AccessTokenStorageProtocol = AccessTokenStorage.shared

    func getPetInfoGeneral(petID: String? = nil, userID: String? = nil, petTypeID: String? = nil, breedID: String? = nil, gender: String? = nil, completion: @escaping (Result<[Pet], Error>) -> ()) {
        let endpoint = Endpoint.PetService.getPetInfoGeneral

        let parameters = [
            "petID": petID,
            "userID": userID,
            "petTypeID": petTypeID,
            "breedID": breedID,
            "gender": gender
        ].filter { $0.value != nil }

        AF.request(endpoint.url, method: endpoint.method, parameters: parameters, headers: [accessTokenStorage.authHeader])
            .validate()
            .responseDecodable(of: [Pet].self) { response in
#if DEBUG
                debugPrint(response)
#endif

                guard let pets = response.value else {
                    if let error = response.error {
                        switch error {
                            case .responseValidationFailed(reason: .unacceptableStatusCode(code: 500)):
                                completion(.failure(APIError.serverDown))
                            default:
                                completion(.failure(error))
                        }
                    }
                    return
                }

                completion(.success(pets))
            }
    }
}
