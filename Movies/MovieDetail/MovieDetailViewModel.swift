//
//  MovieDetailViewModel.swift
//  Movies
//
//  Created by onton on 25.11.2022.
//

import RxCocoa
import RxSwift

protocol MovieDetailViewModelProtocol {
    var output: MovieDetailViewModelOutputProtocol { get }
}

protocol MovieDetailViewModelOutputProtocol {
    var imageURL: Driver<URL?> { get }
    var title: Driver<String?> { get }
    var overview: Driver<String?> { get }
    var releaseYear: Driver<String?> { get }
    var errorText: Driver<String?> { get }

    var isErrorVisible: Driver<Bool> { get }
}

final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    let output: MovieDetailViewModelOutputProtocol

    init(id: Int, moviesService: MoviesServiceProtocol, imageUrlBuilder: ImageUrlBuilderProtocol) {
        let movie = moviesService.movieDetails(by: id)

        let releaseYear = movie.map { movie -> String? in
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-DD"
            if let date = formatter.date(from: movie.releaseDate) {
                formatter.dateFormat = "YYYY"
                return formatter.string(from: date)
            } else {
                return nil
            }
        }
        let movieDriver = movie.map(Optional.init)
            .asDriver(onErrorJustReturn: nil)

        output = Output(
            imageURL: movieDriver.compactMap { $0 }.map(imageUrlBuilder.posterUrl(for:)),
            title: movieDriver.map(\.?.originalTitle),
            overview: movieDriver.map(\.?.overview),
            releaseYear: releaseYear.asDriver(onErrorJustReturn: nil),
            errorText: movie.map { _ in nil }.asDriver { .just($0.localizedDescription) }
        )
    }
}

extension MovieDetailViewModel {
    struct Output: MovieDetailViewModelOutputProtocol {
        let imageURL: Driver<URL?>
        let title: Driver<String?>
        let overview: Driver<String?>
        let releaseYear: Driver<String?>
        let errorText: Driver<String?>

        var isErrorVisible: Driver<Bool> {
            errorText.map { $0 != nil }
        }
    }
}
