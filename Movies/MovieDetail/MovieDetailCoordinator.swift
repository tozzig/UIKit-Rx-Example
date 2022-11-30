//
//  MovieDetailCoordinator.swift
//  Movies
//
//  Created by onton on 25.11.2022.
//

import RxCocoa
import RxSwift

final class MovieDetailCoordinator: BaseCoordinator<Void> {
    private let navigationController: UINavigationController
    private let movieId: Int
    private let dependenciesProvider: DependenciesProvider

    init(
        navigationController: UINavigationController,
        movieId: Int,
        dependenciesProvider: DependenciesProvider
    ) {
        self.navigationController = navigationController
        self.movieId = movieId
        self.dependenciesProvider = dependenciesProvider
    }

    override func start(nextScene: Scene?, animated: Bool) -> Driver<Void> {
        let viewModel = MovieDetailViewModel(id: movieId, dependencies: dependenciesProvider)
        let view = MovieDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(view, animated: animated)

        return view.rx.deallocated.asDriverOnErrorJustComplete()
    }
}
