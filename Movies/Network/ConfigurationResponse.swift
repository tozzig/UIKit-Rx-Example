//
//  ConfigurationResponse.swift
//  Movies
//
//  Created by onton on 24.11.2022.
//

import Foundation

struct ConfigurationResponse: Decodable {
    struct Images: Decodable {
        let baseUrl: String?
        let posterSizes: [String]?
    }

    let images: Images?
}
