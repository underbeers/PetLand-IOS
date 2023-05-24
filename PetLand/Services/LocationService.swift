//
//  LocationService.swift
//  PetLand
//
//  Created by Никита Сигал on 23.05.2023.
//

import Alamofire
import Foundation

extension Endpoint {
    enum LocationService {
        static let getCities = Endpoint(path: "/location/city", method: .get)
        static let getDistricts = Endpoint(path: "/location/district", method: .get)
    }
}

enum LocationServiceError: Error {}

protocol LocationServiceProtocol {
    func getCities(id: Int?, _ completion: @escaping (Result<[City], Error>) -> ())
    func getDistricts(id: Int?, cityID: Int?, _ completion: @escaping (Result<[District], Error>) -> ())
}

extension LocationServiceProtocol {
    func getCities(id: Int? = nil, _ completion: @escaping (Result<[City], Error>) -> ()) {
        getCities(id: id, completion)
    }

    func getDistricts(id: Int? = nil, cityID: Int? = nil, _ completion: @escaping (Result<[District], Error>) -> ()) {
        getDistricts(id: id, cityID: cityID, completion)
    }
}

final class LocationService: LocationServiceProtocol {
    static let shared = LocationService()

    func getCities(id: Int?, _ completion: @escaping (Result<[City], Error>) -> ()) {
        let endpoint = Endpoint.LocationService.getCities

        let parameters = [
            "id": id
        ].compactMapValues { $0 != nil ? String($0!) : nil }

        AF.request(endpoint.url, method: endpoint.method, parameters: parameters)
            .validate()
            .responseDecodable(of: [City].self, decoder: JSONDecoder.custom) { response in
                debugPrint(response)

                guard let cities = response.value else {
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

                completion(.success(cities))
            }
    }

    func getDistricts(id: Int?, cityID: Int?, _ completion: @escaping (Result<[District], Error>) -> ()) {
        let endpoint = Endpoint.LocationService.getDistricts

        let parameters = [
            "id": id,
            "cityID": cityID
        ].compactMapValues { $0 != nil ? String($0!) : nil }

        AF.request(endpoint.url, method: endpoint.method, parameters: parameters)
            .validate()
            .responseDecodable(of: [District].self, decoder: JSONDecoder.custom) { response in
                debugPrint(response)

                guard let cities = response.value else {
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

                completion(.success(cities))
            }
    }
}
