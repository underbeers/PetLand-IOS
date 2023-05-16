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
        static let getAdvertCards = Endpoint(path: "/adverts", method: .get)
    }
}

enum AdvertServiceError: Error {}

protocol AdvertServiceProtocol {
    func getAdvertCards(id: Int?, userID: String?, petID: Int?, typeID: Int?, breedID: Int?, gender: String?, minPrice: Int?, maxPrice: Int?, cityID: Int?, districtID: Int?, status: String?, sort: String?, page: Int?, perPage: Int?, _ completion: @escaping (Result<AdvertCardList, Error>) -> ())
}

extension AdvertServiceProtocol {
    func getAdvertCards(id: Int? = nil, userID: String? = nil, petID: Int? = nil, typeID: Int? = nil, breedID: Int? = nil, gender: String? = nil, minPrice: Int? = nil, maxPrice: Int? = nil, cityID: Int? = nil, districtID: Int? = nil, status: String? = nil, sort: String? = nil, page: Int? = nil, perPage: Int? = nil, _ completion: @escaping (Result<AdvertCardList, Error>) -> ()) {
        getAdvertCards(id: id, userID: userID, petID: petID, typeID: typeID, breedID: breedID, gender: gender, minPrice: minPrice, maxPrice: maxPrice, cityID: cityID, districtID: districtID, status: status, sort: sort, page: page, perPage: perPage, completion)
    }
}

final class AdvertService: AdvertServiceProtocol {
    static let shared = AdvertService()

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

        AF.request(endpoint.url, method: endpoint.method, parameters: parameters)
            .validate()
            .responseDecodable(of: AdvertCardList.self) { response in
                debugPrint(response)
                
                guard let cardList = response.value  else {
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
}
