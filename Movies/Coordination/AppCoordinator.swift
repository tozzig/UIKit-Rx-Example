//
//  AppCoordinator.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    private let window: UIWindow
    private let configurationService: ConfigurationService

    init(window: UIWindow, configurationService: ConfigurationService) {
        self.window = window
        self.configurationService = configurationService
        super.init()
    }

    override func start(nextScene: Scene?, params: [String: Any]?, animated: Bool) -> Observable<Void> {
        window.rootViewController = LoadingViewController(nib: R.nib.loadingViewController)
        window.makeKeyAndVisible()

        switch nextScene {
        case .moviesList:
            return configurationService.getConfiguration()
                .compactMap(\.value)
                .compactMap(Configuration.init(configurationResponse:))
                .observe(on: MainScheduler.asyncInstance)
                .flatMap(startMoviesListScene(configuration:))
        default:
            return .never()
        }
    }

    private func startMoviesListScene(configuration: Configuration) -> Observable<Void> {
        return coordinate(to: MoviesListCoordinator(window: window, configuration: configuration))
    }
}
