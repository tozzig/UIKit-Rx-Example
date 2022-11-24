//
//  MoviesListResponse.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import Foundation

struct MoviesListResponse: Decodable {
    let results: [MovieListItem]
}
