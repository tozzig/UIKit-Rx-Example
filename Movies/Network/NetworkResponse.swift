//
//  NetworkResponse.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import Foundation

enum ResponseError: Error {
    case parsingError(Error)
    case networkError(Error)
}

enum NetworkResponse<Value> {
    case success(Value)
    case failure(ResponseError)

    var value: Value? {
        switch self {
        case let .success(value):
            return value
        default:
            return nil
        }
    }

    var error: ResponseError? {
        switch self {
        case let .failure(error):
            return error
        default:
            return nil
        }
    }
}
