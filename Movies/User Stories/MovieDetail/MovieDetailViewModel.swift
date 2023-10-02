//
//  MovieDetailViewModel.swift
//  Movies
//
//  Created by onton on 25.11.2022.
//

import RxCocoa
import RxSwift

typealias MovieDetailViewModelDependencies = MoviesServiceProvider & ImageUrlBuilderProvider

protocol MovieDetailViewModelProtocol {
    var imageURL: Driver<URL?> { get }
    var title: Driver<String> { get }
    var overview: Driver<String> { get }
    var releaseYear: Driver<String?> { get }
    var errorText: Driver<String?> { get }

    var isErrorVisible: Driver<Bool> { get }
}

final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    let imageURL: Driver<URL?>
    let title: Driver<String>
    let overview: Driver<String>
    let releaseYear: Driver<String?>
    let errorText: Driver<String?>

    var isErrorVisible: Driver<Bool> {
        errorText.map { $0 != nil }
    }

    convenience init(id: Int, dependencies: MovieDetailViewModelDependencies) {
        self.init(id: id, moviesService: dependencies.moviesService, imageUrlBuilder: dependencies.imageUrlBuilder)
    }

    init(id: Int, moviesService: Single<MoviesServiceProtocol>, imageUrlBuilder: Single<ImageUrlBuilderProtocol>) {
        let movie = moviesService.flatMap { $0.movieDetails(by: id) }

        imageURL = movie.asObservable()
            .withLatestFrom(imageUrlBuilder.asObservable()) { ($0, $1) }
            .map { $1.posterUrl(for: $0) }
            .asDriver(onErrorJustReturn: nil)

        title = movie
            .map(\.originalTitle)
            .asDriverOnErrorJustComplete()

        overview = movie
            .map(\.overview)
            .asDriverOnErrorJustComplete()

        releaseYear = movie.map(\.releaseDate)
            .map(DateFormatters.convertStringFromFullDateToYears)
            .asDriver(onErrorJustReturn: nil)

        errorText = movie
            .map { _ in nil }
            .asDriver { .just($0.localizedDescription) }
    }
}
