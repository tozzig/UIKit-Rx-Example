//
//  DependencyContainer.swift
//  Movies
//
//  Created by onton on 30.11.2022.
//

import RxRelay
import RxSwift

typealias DependenciesProvider = ImageUrlBuilderProvider & MoviesServiceProvider

protocol ImageUrlBuilderProvider {
    var imageUrlBuilder: Single<ImageUrlBuilderProtocol> { get }
}

protocol MoviesServiceProvider {
    var moviesService: Single<MoviesServiceProtocol> { get }
}

final class DependencyContainer: DependenciesProvider {
    let imageUrlBuilder: Single<ImageUrlBuilderProtocol>
    let moviesService: Single<MoviesServiceProtocol>

    init() {
        let networkProvider = NetworkProvider()
        let configurationService = ConfigurationService(networkProvider: networkProvider)
        imageUrlBuilder = configurationService.getConfiguration()
            .map(Configuration.init)
            .map(ImageUrlBuilder.init)
        moviesService = .just(MoviesService(networkProvider: networkProvider))
    }
}
