//
//  MovieListCellViewModel.swift
//  Movies
//
//  Created by onton on 29.11.2022.
//

import RxCocoa
import RxSwift

protocol MovieListCellViewModelProtocol {
    var imageURL: Driver<URL?> { get }
    var title: String { get }
    var releaseYear: String? { get }
}

final class MovieListCellViewModel: MovieListCellViewModelProtocol {
    let imageURL: Driver<URL?>
    let title: String
    let releaseYear: String?

    init(movieListItem: MovieListItem, imageUrlBuilder: Single<ImageUrlBuilderProtocol>) {
        title = movieListItem.originalTitle
        releaseYear = DateFormatters.convertStringFromFullDateToYears(movieListItem.releaseDate)
        imageURL = imageUrlBuilder
            .map { $0.thumbnailImageURL(for: movieListItem) }
            .asDriver(onErrorJustReturn: nil)
    }
}
