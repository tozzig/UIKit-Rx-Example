//
//  MovieListCellViewModel.swift
//  Movies
//
//  Created by onton on 29.11.2022.
//

import RxCocoa
import RxSwift

protocol MovieListCellViewModelProtocol {
    var output: MovieListCellViewModelOutputProtocol { get }
}

protocol MovieListCellViewModelOutputProtocol {
    var imageURL: Driver<URL?> { get }
    var title: Driver<String> { get }
    var releaseYear: Driver<String> { get }
}

final class MovieListCellViewModel: MovieListCellViewModelProtocol {
    let output: MovieListCellViewModelOutputProtocol

    init(movieListItem: MovieListItem, moviesService: MoviesServiceProtocol, imageUrlBuilder: ImageUrlBuilderProtocol) {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        let releaseYear: Driver<String>
        if let date = formatter.date(from: movieListItem.releaseDate) {
            formatter.dateFormat = "YYYY"
            releaseYear = .just(formatter.string(from: date))
        } else {
            releaseYear = .just("")
        }
        output = Output(
            imageURL: .just(imageUrlBuilder.thumbnailImageURL(for: movieListItem)),
            title: .just(movieListItem.originalTitle),
            releaseYear: releaseYear
        )
    }
}

extension MovieListCellViewModel {
    struct Output: MovieListCellViewModelOutputProtocol {
        let imageURL: Driver<URL?>
        let title: Driver<String>
        let releaseYear: Driver<String>
    }
}
