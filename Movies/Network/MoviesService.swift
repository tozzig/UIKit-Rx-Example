//
//  MoviesService.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import RxSwift

class MoviesService {
    func moviesList(page: Int = 1) -> Single<MoviesListResponse> {
        NetworkProvider.shared.rx.request(request: MoviesAPI.moviesList(page))
    }

    func movieDetails(by id: Int) -> Single<MovieDetailResponse> {
        NetworkProvider.shared.rx.request(request: MoviesAPI.movieDetail(id))
    }
}
