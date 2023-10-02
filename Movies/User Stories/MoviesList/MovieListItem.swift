//
//  MovieListItem.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import Foundation

struct MovieListItem: Decodable, Equatable {
    let posterPath: String?
    let releaseDate: String
    let originalTitle: String
    let id: Int
}
