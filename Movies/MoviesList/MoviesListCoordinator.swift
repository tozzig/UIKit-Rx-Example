//
//  MoviesListCoordinator.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import RxSwift

class MoviesListCoordinator: BaseCoordinator<Void> {

    private let window: UIWindow
    private let configuration: Configuration

    init(window: UIWindow, configuration: Configuration) {
        self.window = window
        self.configuration = configuration
        super.init()
    }

    override func start(nextScene: Scene?, params: [String: Any]?, animated: Bool) -> Observable<Void> {
        guard let imageUrlBuilder = ImageUrlBuilder(configuration: configuration) else {
            return .never()
        }

        let moviesService = MoviesService()
        let viewModel = MoviesViewModel(moviesService: moviesService, imageUrlBuilder: imageUrlBuilder)
        let view = MoviesViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: view)
        window.rootViewController = navigationController

        viewModel.output.selectedMovieId
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [unowned self] id  in
                startMovieDetail(
                    in: navigationController,
                    movieId: id,
                    moviesService: moviesService,
                    imageUrlBuilder: imageUrlBuilder
                )
            })
            .disposed(by: disposeBag)

        return .never()
    }

    private func startMovieDetail(
        in navigationController: UINavigationController,
        movieId: Int,
        moviesService: MoviesServiceProtocol,
        imageUrlBuilder: ImageUrlBuilderProtocol
    ) {
        let movieDetailCoordinator = MovieDetailCoordinator(
            navigationController: navigationController,
            movieId: movieId,
            moviesService: moviesService,
            imageUrlBuilder: imageUrlBuilder
        )
        coordinate(to: movieDetailCoordinator)
            .subscribe()
            .disposed(by: disposeBag)
    }
}
