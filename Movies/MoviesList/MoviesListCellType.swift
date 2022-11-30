//
//  MoviesListCellType.swift
//  Movies
//
//  Created by onton on 30.11.2022.
//

import Foundation

enum MoviesListCellType: Equatable {
    case movie(MovieListItem)
    case noResults
    case loading
}
