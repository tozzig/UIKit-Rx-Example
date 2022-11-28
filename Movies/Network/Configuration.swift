//
//  Configuration.swift
//  Movies
//
//  Created by onton on 24.11.2022.
//

import Foundation

struct Configuration {
    let baseURL: URL
    let posterSizes: [String]

    init?(configurationResponse: ConfigurationResponse) {
        guard
            let baseUrlString = configurationResponse.images?.baseUrl,
            let baseURL = URL(string: baseUrlString),
            let posterSizes = configurationResponse.images?.posterSizes
        else {
            return nil
        }
        self.baseURL = baseURL
        self.posterSizes = posterSizes
    }
}
