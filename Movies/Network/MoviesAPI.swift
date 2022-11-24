//
//  MoviesAPI.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import Alamofire

enum MoviesAPI {
    private var key: String {
        "c9856d0cb57c3f14bf75bdc6c063b8f3"
    }
    
    case moviesList
    case movieDetail(Int)
}

extension MoviesAPI: RequestProtocol {
    var baseURL: URL {
        URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        switch self {
        case .moviesList:
            return "/discover/movie"
        case .movieDetail(let movieID):
            return "/movie/\(movieID)"
        }
    }

    var parameters: Parameters? {
        [ParametersKeys.apiKey.rawValue: key]
    }
}

private extension MoviesAPI {
    enum ParametersKeys: String {
        case apiKey = "api_key"
    }
}
