//
//  AdvertService.swift
//  PetLand
//
//  Created by Никита Сигал on 12.05.2023.
//

import Alamofire
import Foundation

extension Endpoint {
    enum AdvertService {
        static let getAdvertCards = Endpoint(path: "/auth/adverts", method: .get)
        static let getAdvert = Endpoint(path: "/auth/adverts/full", method: .get)
        static let createAdvert = Endpoint(path: "/adverts/new", method: .post)
        static let updateAdvert = Endpoint(path: "/adverts/update", method: .put)
        static let deleteAdvert = Endpoint(path: "/adverts/delete", method: .delete)
    }
}

enum AdvertServiceError: Error {}

protocol AdvertServiceProtocol {
    func getAdvertCards(id: Int?, userID: String?, petID: Int?, typeID: Int?, breedID: Int?, gender: String?, minPrice: Int?, maxPrice: Int?, cityID: Int?, districtID: Int?, status: String?, sort: String?, page: Int?, perPage: Int?, _ completion: @escaping (Result<AdvertCardList, Error>) -> ())
    func getAdvert(id: Int, _ completion: @escaping (Result<Advert, Error>) -> ())
    func commitAdvert(_ advert: AdvertEdit, isNew: Bool, _ completion: @escaping (Error?) -> ())
    func deleteAdvert(advertID: Int, _ completion: @escaping (Error?) -> ())
}

extension AdvertServiceProtocol {
    func getAdvertCards(id: Int? = nil, userID: String? = nil, petID: Int? = nil, typeID: Int? = nil, breedID: Int? = nil, gender: String? = nil, minPrice: Int? = nil, maxPrice: Int? = nil, cityID: Int? = nil, districtID: Int? = nil, status: String? = nil, sort: String? = nil, page: Int? = nil, perPage: Int? = nil, _ completion: @escaping (Result<AdvertCardList, Error>) -> ()) {
        getAdvertCards(id: id, userID: userID, petID: petID, typeID: typeID, breedID: breedID, gender: gender, minPrice: minPrice, maxPrice: maxPrice, cityID: cityID, districtID: districtID, status: status, sort: sort, page: page, perPage: perPage, completion)
    }
}

final class AdvertService: AdvertServiceProtocol {
    static let shared = AdvertService()
    private let accessTokenStorage: AccessTokenStorageProtocol = AccessTokenStorage.shared

    func getAdvertCards(id: Int?, userID: String?, petID: Int?, typeID: Int?, breedID: Int?, gender: String?, minPrice: Int?, maxPrice: Int?, cityID: Int?, districtID: Int?, status: String?, sort: String?, page: Int?, perPage: Int?, _ completion: @escaping (Result<AdvertCardList, Error>) -> ()) {
        let endpoint = Endpoint.AdvertService.getAdvertCards

        // Int args
        let intArgs: [String: String] = [
            "id": id,
            "petCardID": petID,
            "petTypeID": typeID,
            "breedID": breedID,
            "minPrice": minPrice,
            "maxPrice": maxPrice,
            "cityID": cityID,
            "districtID": districtID,
            "page": page,
            "perPage": perPage
        ].compactMapValues { $0 != nil ? String($0!) : nil }

        let stringArgs: [String: String] = [
            "userID": userID,
            "gender": gender,
            "status": status,
            "sort": sort
        ].compactMapValues { $0 }

        let parameters = intArgs.merging(stringArgs, uniquingKeysWith: { first, _ in first })

        AF.request(endpoint.url, method: endpoint.method, parameters: parameters, headers: [accessTokenStorage.authHeader])
            .validate()
            .responseDecodable(of: AdvertCardList.self, decoder: JSONDecoder.custom) { response in
                debugPrint(response)

                guard let cardList = response.value else {
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

                completion(.success(cardList))
            }
    }

    func getAdvert(id: Int, _ completion: @escaping (Result<Advert, Error>) -> ()) {
        let endpoint = Endpoint.AdvertService.getAdvert

        let parameters = ["id": String(id)]

        AF.request(endpoint.url, method: endpoint.method, parameters: parameters, headers: [accessTokenStorage.authHeader])
            .validate()
            .responseDecodable(of: Advert.self, decoder: JSONDecoder.custom) { response in
                debugPrint(response)

                guard let advert = response.value else {
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

                completion(.success(advert))
            }
    }
    
    func commitAdvert(_ advert: AdvertEdit, isNew: Bool, _ completion: @escaping (Error?) -> ()) {
        let endpoint = isNew ? Endpoint.AdvertService.createAdvert : Endpoint.AdvertService.updateAdvert
        
        let urlParmater = isNew ? "" : "?id=\(advert.id)"
        
        AF.request(endpoint.url + urlParmater, method: endpoint.method, parameters: advert, encoder: JSONParameterEncoder(encoder: .custom), headers: [accessTokenStorage.authHeader])
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
    
    func deleteAdvert(advertID: Int, _ completion: @escaping (Error?) -> ()) {
        let endpoint = Endpoint.AdvertService.deleteAdvert
        
        AF.request(endpoint.url, method: endpoint.method, parameters: ["id": advertID], encoder: URLEncodedFormParameterEncoder(), headers: [accessTokenStorage.authHeader])
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
