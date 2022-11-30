//
//  Configuration.swift
//  Movies
//
//  Created by onton on 24.11.2022.
//

import Foundation

protocol ConfigurationProtocol {
    var baseURL: URL { get }
    var posterSizes: [String] { get }
}

private enum Constants {
    static let wrongConfigurationData = "Couldn't create configuration data from response"
}

struct Configuration: ConfigurationProtocol {
    enum ConfigurationError: String, LocalizedError {
        case wrongConfigurationData

        var errorDescription: String? {
            Constants.wrongConfigurationData
        }
    }

    let baseURL: URL
    let posterSizes: [String]

    init(configurationResponse: ConfigurationResponse) throws {
        guard
            let baseUrlString = configurationResponse.images?.baseUrl,
            let baseURL = URL(string: baseUrlString),
            let posterSizes = configurationResponse.images?.posterSizes
        else {
            throw ConfigurationError.wrongConfigurationData
        }
        self.baseURL = baseURL
        self.posterSizes = posterSizes
    }
}
