//
//  ConfigurationAPI.swift
//  Movies
//
//  Created by onton on 27.11.2022.
//

import Alamofire

enum ConfigurationAPI {
    private var key: String {
        "c9856d0cb57c3f14bf75bdc6c063b8f3"
    }

    case getConfiguration
}

extension ConfigurationAPI: RequestProtocol {
    var baseURL: URL {
        URL(string: "https://api.themoviedb.org/3")!
    }

    var path: String {
        "/configuration"
    }

    var parameters: Parameters? {
        [ParametersKeys.apiKey.rawValue: key]
    }
}

private extension ConfigurationAPI {
    enum ParametersKeys: String {
        case apiKey = "api_key"
    }
}
