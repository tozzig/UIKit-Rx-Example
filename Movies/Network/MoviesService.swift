//
//  MoviesService.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import RxSwift

protocol MoviesServiceProtocol {
    func moviesList(page: Int) -> Single<MoviesListResponse>
    func movieDetails(by id: Int) -> Single<MovieDetailItem>
}

final class MoviesService: MoviesServiceProtocol {
    private let networkProvider: NetworkProviderProtocol

    init(networkProvider: NetworkProviderProtocol) {
        self.networkProvider = networkProvider
    }

    func moviesList(page: Int) -> Single<MoviesListResponse> {
        networkProvider.request(request: MoviesAPI.moviesList(page))
    }

    func movieDetails(by id: Int) -> Single<MovieDetailItem> {
        networkProvider.request(request: MoviesAPI.movieDetail(id))
    }
}

extension MoviesServiceProtocol {
    func moviesList(page: Int = 1) -> Single<MoviesListResponse> {
        moviesList(page: page)
    }
}
