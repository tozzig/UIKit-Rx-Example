//
//  MovieListCellViewModel.swift
//  Movies
//
//  Created by onton on 29.11.2022.
//

import RxCocoa
import RxSwift

typealias MoviesListCellViewModelDependencies = ImageUrlBuilderProvider

protocol MovieListCellViewModelProtocol {
    var imageURL: Driver<URL?> { get }
    var title: String { get }
    var releaseYear: String? { get }
}

final class MovieListCellViewModel: MovieListCellViewModelProtocol {
    let imageURL: Driver<URL?>
    let title: String
    let releaseYear: String?

    init(movieListItem: MovieListItem, dependencies: MoviesListCellViewModelDependencies) {
        title = movieListItem.originalTitle
        releaseYear = DateFormatters.convertStringFromFullDateToYears(movieListItem.releaseDate)
        imageURL = dependencies.imageUrlBuilder
            .map { $0.thumbnailImageURL(for: movieListItem) }
            .asDriver(onErrorJustReturn: nil)
    }
}
