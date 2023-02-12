//
//  APIService.swift
//  PetLand
//
//  Created by Никита Сигал on 30.01.2023.
//

import Foundation

// MARK: Convenience extension

extension URLSession {
    func makeRequest(
        _ urlRequest: URLRequest,
        _ completion: @escaping (Result<(URLResponse, Data?), Error>) -> Void
    ) -> URLSessionDataTask {
        dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }

            guard let response = response
            else {
                DispatchQueue.main.async { completion(.failure(APIService.Error.noData)) }
                return
            }

            DispatchQueue.main.async { completion(.success((response, data))) }
        }
    }
}

// MARK: Base Enum

enum APIService {}

// MARK: Errors

extension APIService {
    enum Error: Swift.Error {
        case invalidEndPoint,
             invalidResponse,
             noData,
             encodeError,
             decodeError,
             failedWithStatusCode(Int)
    }
}

// MARK: EndPoint Protocol

protocol APIEndPoint {
    associatedtype ResponseType: APIResponse

    var httpMethod: String { get }
    var port: Int { get }
    var baseURLString: String { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var body: [String: String]? { get }
}

extension APIEndPoint {
    var url: String {
        baseURLString + path
    }

    func call(_ completion: @escaping (Result<ResponseType?, Error>) -> Void) {
        guard let url = URL(string: url)
        else {
            completion(.failure(APIService.Error.invalidEndPoint))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod

        headers?.forEach { header, value in
            urlRequest.setValue(value, forHTTPHeaderField: header)
        }

        guard let httpBody = try? JSONEncoder().encode(body)
        else {
            completion(.failure(APIService.Error.encodeError))
            return
        }
        urlRequest.httpBody = httpBody

        URLSession.shared.makeRequest(urlRequest) { result in
            switch result {
                case .success(let (response, data)):
                    // Check, if we have a status code
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode
                    else {
                        completion(.failure(APIService.Error.invalidResponse))
                        return
                    }

                    // Check, if the request succeeded
                    guard 200 ..< 299 ~= statusCode
                    else {
                        completion(.failure(APIService.Error.failedWithStatusCode(statusCode)))
                        return
                    }

                    // Check, if the reponse is supposed to have data
                    guard ResponseType.shouldExist
                    else {
                        completion(.success(nil))
                        return
                    }

                    // Check, if the response has data
                    guard let data
                    else {
                        completion(.failure(APIService.Error.noData))
                        return
                    }

                    // Decode the data
                    do {
                        let data = try JSONDecoder().decode(ResponseType.self, from: data)
                        completion(.success(data))
                    } catch {
                        completion(.failure(APIService.Error.decodeError))
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
        }.resume()
    }
}

// MARK: API Responses

protocol APIResponse: Codable {
    static var shouldExist: Bool { get }
}

extension APIService {
    struct EmptyResponse: APIResponse {
        static var shouldExist: Bool = false
    }
}

// MARK: EndPoint namespace

extension APIService {
    enum EndPoints {}
}
