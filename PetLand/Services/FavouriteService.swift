//
//  FavouriteService.swift
//  PetLand
//
//  Created by Никита Сигал on 24.05.2023.
//

import Alamofire
import Foundation

extension Endpoint {
    enum FavouriteService {
        static let addFavourite = Endpoint(path: "/favorites/add", method: .post)
        static let getFavourites = Endpoint(path: "/favorites", method: .get)
        static let removeFavourite = Endpoint(path: "/favorites/delete", method: .delete)
    }
}

enum FavouriteSerivceError: Error {}

enum FavouriteType: String {
    case advert,
         specialist,
         organization,
         event
}

protocol FavouriteServiceProtocol {
    func addFavourite(_ type: FavouriteType, id: Int, _ completion: @escaping (Error?) -> ())
    func getFavourites(_ completion: @escaping (Result<Favourites, Error>) -> ())
    func removeFavourite(id: Int, _ completion: @escaping (Error?) -> ())
}

final class FavouriteService: FavouriteServiceProtocol {
    static let shared = FavouriteService()
    private let accessTokenStorage: AccessTokenStorageProtocol = AccessTokenStorage.shared

    func addFavourite(_ type: FavouriteType, id: Int, _ completion: @escaping (Error?) -> ()) {
        let endpoint = Endpoint.FavouriteService.addFavourite

        struct FavouriteRequest: Encodable {
            var type: String
            var id: Int
        }
        let parameters = FavouriteRequest(type: type.rawValue, id: id)

        AF.request(endpoint.url, method: endpoint.method, parameters: parameters, encoder: JSONParameterEncoder(encoder: .custom), headers: [accessTokenStorage.authHeader])
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
                } else {
                    completion(nil)
                }
            }
    }

    func getFavourites(_ completion: @escaping (Result<Favourites, Error>) -> ()) {
        let endpoint = Endpoint.FavouriteService.getFavourites

        AF.request(endpoint.url, method: endpoint.method, headers: [accessTokenStorage.authHeader])
            .validate()
            .responseDecodable(of: Favourites.self, decoder: JSONDecoder.custom) { response in
                debugPrint(response)
                
                guard let favourites = response.value else {
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

                completion(.success(favourites))
            }
    }

    func removeFavourite(id: Int, _ completion: @escaping (Error?) -> ()) {
        let endpoint = Endpoint.FavouriteService.removeFavourite

        let parameters = [
            "id": String(id),
        ]

        AF.request(endpoint.url, method: endpoint.method, parameters: parameters, headers: [accessTokenStorage.authHeader])
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
                }

                completion(nil)
            }
    }
}
