//
//  MoviesListCoordinator.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import RxCocoa
import RxSwift

final class MoviesListCoordinator: BaseCoordinator<Void> {
    private let window: UIWindow
    private let dependenciesProvider: DependenciesProvider

    init(window: UIWindow, dependenciesProvider: DependenciesProvider) {
        self.window = window
        self.dependenciesProvider = dependenciesProvider
        super.init()
    }

    override func start(nextScene: Scene?, animated: Bool) -> Driver<Void> {
        let viewModel = MoviesViewModel(dependencies: dependenciesProvider)
        let view = MoviesViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: view)
        window.rootViewController = navigationController

        viewModel.selectedMovieId
            .asDriverOnErrorJustComplete()
            .drive { [weak self] id in
                self?.startMovieDetail(in: navigationController, with: id)
            }
            .disposed(by: disposeBag)

        return .never()
    }

    private func startMovieDetail(in navigationController: UINavigationController, with movieId: Int) {
        let movieDetailCoordinator = MovieDetailCoordinator(
            navigationController: navigationController,
            movieId: movieId,
            dependenciesProvider: dependenciesProvider
        )
        coordinate(to: movieDetailCoordinator)
            .drive()
            .disposed(by: disposeBag)
    }
}
