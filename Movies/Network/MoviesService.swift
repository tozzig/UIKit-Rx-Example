//
//  MoviesService.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import RxSwift

protocol MoviesServiceProtocol {
    func moviesList(page: Int) -> Single<MoviesListResponse>
    func movieDetails(by id: Int) -> Single<MovieDetailResponse>
}

final class MoviesService: MoviesServiceProtocol {
    func moviesList(page: Int) -> Single<MoviesListResponse> {
        NetworkProvider.shared.rx.request(request: MoviesAPI.moviesList(page))
    }

    func movieDetails(by id: Int) -> Single<MovieDetailResponse> {
        NetworkProvider.shared.rx.request(request: MoviesAPI.movieDetail(id))
    }
}

extension MoviesServiceProtocol {
    func moviesList(page: Int = 1) -> Single<MoviesListResponse> {
        moviesList(page: page)
    }
}
