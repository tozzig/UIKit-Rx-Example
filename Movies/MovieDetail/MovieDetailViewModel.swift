//
//  MovieDetailViewModel.swift
//  Movies
//
//  Created by onton on 25.11.2022.
//

import RxCocoa
import RxSwift

final class MovieDetailViewModel {
    let output: Output

    init(id: Int, moviesService: MoviesService, imageUrlBuilder: ImageUrlBuilder) {
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
            errorText: movie.map { _ in nil }.asDriver {
                .just($0.localizedDescription)
            }
        )
    }
}

extension MovieDetailViewModel {
    struct Output {
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
