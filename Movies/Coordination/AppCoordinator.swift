//
//  AppCoordinator.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import RxSwift

class AppCoordinator: BaseCoordinator<Void> {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
        super.init()
    }

    override func start(nextScene: Scene? = nil, params: [String: Any]?, animation: Bool = true) -> Observable<Void> {
        switch nextScene {
        case .moviesList:
            return startMoviesListScene()
        default:
            return .never()
        }
    }

    private func startMoviesListScene() -> Observable<Void> {
        return coordinate(to: MoviesListCoordinator(window: window))
    }

}
