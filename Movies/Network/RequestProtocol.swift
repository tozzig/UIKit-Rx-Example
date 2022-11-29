//
//  RequestProtocol.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import Alamofire

protocol RequestProtocol: URLConvertible {
    var baseURL: URL { get }

    var path: String { get }

    var method: HTTPMethod { get }

    var headers: HTTPHeaders? { get }

    var parameters: Parameters? { get }

    var paramsEncoding: ParameterEncoding { get }
}

extension RequestProtocol {
    var path: String {
        ""
    }

    var method: HTTPMethod {
        .get
    }

    var headers: HTTPHeaders? {
        nil
    }

    var parameters: Parameters? {
        nil
    }

    var paramsEncoding: ParameterEncoding {
        URLEncoding.default
    }
}

extension RequestProtocol {
    func asURL() throws -> URL {
        var originalRequest: URLRequest?
        originalRequest = try URLRequest(url: baseURL.appendingPathComponent(path), method: method, headers: headers)
        let encodedURLRequest = try paramsEncoding.encode(originalRequest!, with: parameters)
        return encodedURLRequest.url!
    }
}
