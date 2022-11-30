//
//  AppCoordinator.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import RxCocoa
import RxSwift

final class AppCoordinator: BaseCoordinator<Void> {
    private let window: UIWindow
    private let dependenciesProvider: DependenciesProvider

    init(window: UIWindow, dependenciesProvider: DependenciesProvider) {
        self.window = window
        self.dependenciesProvider = dependenciesProvider
        super.init()
    }

    override func start(nextScene: Scene?, animated: Bool) -> Driver<Void> {
        window.rootViewController = UIViewController()
        window.makeKeyAndVisible()

        switch nextScene {
        case .moviesList:
            return startMoviesListScene(dependenciesProvider: dependenciesProvider)
        default:
            return .never()
        }
    }

    private func startMoviesListScene(dependenciesProvider: DependenciesProvider) -> Driver<Void> {
        coordinate(to: MoviesListCoordinator(window: window, dependenciesProvider: dependenciesProvider))
    }
}
