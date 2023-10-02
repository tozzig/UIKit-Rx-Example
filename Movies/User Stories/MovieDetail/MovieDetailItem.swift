//
//  MovieDetailItem.swift
//  Movies
//
//  Created by onton on 25.11.2022.
//

import Foundation

struct MovieDetailItem: Decodable {
    let posterPath: String?
    let releaseDate: String
    let originalTitle: String
    let overview: String
}
