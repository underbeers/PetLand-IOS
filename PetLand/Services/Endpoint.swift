//
//  Endpoint.swift
//  PetLand
//
//  Created by Никита Сигал on 05.05.2023.
//

import Alamofire
import Foundation

struct Endpoint {
    private static let baseURL = "http://petland-backend-k8s.underbeers.space/api/v1"

    var path: String
    var method: HTTPMethod

    var url: String {
        Endpoint.baseURL + path
    }
}
