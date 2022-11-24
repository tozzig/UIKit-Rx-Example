//
//  MoviesService.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import RxSwift

class MoviesService {

    func moviesList() -> Observable<NetworkResponse<MoviesListResponse>> {
        NetworkProvider.shared.rx.request(request: MoviesAPI.moviesList)
    }
//
//    func currentWeather(by cityName: String) -> Observable<NetworkResponse<CurrentWeatherForecast>> {
//        NetworkProvider.shared.rx.request(request: WeatherAPI.dailyForecast(cityName))
//    }
}
