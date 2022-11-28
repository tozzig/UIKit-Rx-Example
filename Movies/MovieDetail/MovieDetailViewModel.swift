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
            .compactMap(\.value)
            .asDriverOnErrorJustComplete()

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

        output = Output(
            imageURL: movie.map(imageUrlBuilder.posterUrl(for:)),
            title: movie.map(\.originalTitle),
            overview: movie.map(\.overview),
            releaseYear: releaseYear
        )
    }
}

extension MovieDetailViewModel {
    struct Output {
        let imageURL: Driver<URL?>
        let title: Driver<String>
        let overview: Driver<String>
        let releaseYear: Driver<String?>
    }
}
