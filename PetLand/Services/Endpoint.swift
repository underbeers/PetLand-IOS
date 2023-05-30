//
//  Endpoint.swift
//  PetLand
//
//  Created by Никита Сигал on 05.05.2023.
//

import Alamofire
import Foundation

struct Endpoint {
    private static let baseURL = "http://petland-backend.underbeers.space/api/v1"

    var path: String
    var method: HTTPMethod

    var url: String {
        Endpoint.baseURL + path
    }
}

enum APIError: Error {
    case unauthorized
    case serverDown
}

private let formatterShort: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [
        .withFullDate,
        .withFullTime
    ]
    return formatter
}()

private let formatterFull: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [
        .withFullDate,
        .withFullTime,
        .withFractionalSeconds
    ]
    return formatter
}()

extension JSONEncoder {
    static let custom: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .custom { date, encoder in
            var container = encoder.singleValueContainer()
            let dateString = formatterFull.string(from: date)
            try container.encode(dateString)
        }
        return encoder
    }()
}

extension JSONDecoder {
    static let custom: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            if let date = formatterFull.date(from: dateString) {
                return date
            } else if let date = formatterShort.date(from: dateString) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
        }
        return decoder
    }()
}
