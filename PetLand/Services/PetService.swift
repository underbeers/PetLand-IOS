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
        static let getPetInfoGeneral = Endpoint(path: "/petCards", method: .get)
        static let createPet = Endpoint(path: "/petCards/new", method: .post)
        static let getTypes = Endpoint(path: "/petTypes", method: .get)
        static let getBreeds = Endpoint(path: "/breeds", method: .get)
    }
}

enum PetServiceError: Error {}

protocol PetServiceProtocol {
    func getPets(petID: Int?, userID: String?, typeID: Int?, breedID: Int?, isMale: Bool?, completion: @escaping (Result<[Pet], Error>) -> ())
    func getTypes(typeID: Int?, type: String?, completion: @escaping (Result<[PetType], Error>) -> ())
    func getBreeds(typeID: Int?, breedID: Int?, breed: String?, completion: @escaping (Result<[PetBreed], Error>) -> ())
    func createPet(pet: Pet, completion: @escaping (Error?) -> ())
}

final class PetService: PetServiceProtocol {
    static let shared = PetService()

    private let accessTokenStorage: AccessTokenStorageProtocol = AccessTokenStorage.shared

    func getPets(petID: Int? = nil, userID: String? = nil, typeID: Int? = nil, breedID: Int? = nil, isMale: Bool? = nil, completion: @escaping (Result<[Pet], Error>) -> ()) {
        let endpoint = Endpoint.PetService.getPetInfoGeneral

        var parameters: [String: String] = [:]
        if let petID {
            parameters["id"] = String(petID)
        }
        if let userID {
            parameters["userID"] = userID
        }
        if let typeID {
            parameters["petTypeID"] = String(typeID)
        }
        if let breedID {
            parameters["breedID"] = String(breedID)
        }
        if let isMale {
            parameters["gender"] = isMale ? "male" : "female"
        }

        AF.request(endpoint.url, method: endpoint.method, parameters: parameters)
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

    func createPet(pet: Pet, completion: @escaping (Error?) -> ()) {
        let endpoint = Endpoint.PetService.createPet
        
        var pet = pet
        pet.userID = accessTokenStorage.userID

        AF.request(endpoint.url, method: endpoint.method, parameters: pet, encoder: JSONParameterEncoder(), headers: [accessTokenStorage.authHeader])
            .validate()
            .response { response in
#if DEBUG
                debugPrint(response)
#endif
                guard let error = response.error else {
                    completion(nil)
                    return
                }

                switch error {
                    case .responseValidationFailed(reason: .unacceptableStatusCode(code: 500)):
                        completion(APIError.serverDown)
                    default:
                        completion(error)
                }
            }
    }

    func getTypes(typeID: Int?, type: String?, completion: @escaping (Result<[PetType], Error>) -> ()) {
        let endpoint = Endpoint.PetService.getTypes

        var parameters: [String: String] = [:]
        if let typeID {
            parameters["id"] = String(typeID)
        }
        if let type {
            parameters["petType"] = type
        }

        AF.request(endpoint.url, method: endpoint.method, parameters: parameters)
            .validate()
            .responseDecodable(of: [PetType].self) { response in
#if DEBUG
                debugPrint(response)
#endif

                guard let types = response.value else {
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

                completion(.success(types))
            }
    }

    func getBreeds(typeID: Int?, breedID: Int?, breed: String?, completion: @escaping (Result<[PetBreed], Error>) -> ()) {
        let endpoint = Endpoint.PetService.getBreeds

        var parameters: [String: String] = [:]
        if let typeID {
            parameters["petTypeID"] = String(typeID)
        }
        if let breedID {
            parameters["id"] = String(breedID)
        }
        if let breed {
            parameters["breedName"] = breed
        }

        AF.request(endpoint.url, method: endpoint.method, parameters: parameters)
            .validate()
            .responseDecodable(of: [PetBreed].self) { response in
#if DEBUG
                debugPrint(response)
#endif

                guard let breeds = response.value else {
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

                completion(.success(breeds))
            }
    }
}
