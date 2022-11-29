//
//  MovieDetailCoordinator.swift
//  Movies
//
//  Created by onton on 25.11.2022.
//

import RxSwift

class MovieDetailCoordinator: BaseCoordinator<Void> {
    private let navigationController: UINavigationController
    private let movieId: Int
    private let moviesService: MoviesServiceProtocol
    private let imageUrlBuilder: ImageUrlBuilderProtocol

    init(
        navigationController: UINavigationController,
        movieId: Int,
        moviesService: MoviesServiceProtocol,
        imageUrlBuilder: ImageUrlBuilderProtocol
    ) {
        self.navigationController = navigationController
        self.movieId = movieId
        self.moviesService = moviesService
        self.imageUrlBuilder = imageUrlBuilder
    }

    override func start(nextScene: Scene?, params: [String: Any]?, animated: Bool) -> Observable<Void> {
        let viewModel = MovieDetailViewModel(
            id: movieId,
            moviesService: moviesService,
            imageUrlBuilder: imageUrlBuilder
        )
        let view = MovieDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(view, animated: animated)

        return view.rx.deallocated
    }
}
