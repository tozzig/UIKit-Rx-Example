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
        let loading = LoadingViewController(nib: R.nib.loadingViewController)
        window.rootViewController = loading
        window.makeKeyAndVisible()

        switch nextScene {
        case .moviesList:
            return configurationService.getConfiguration()
                .compactMap(Configuration.init(configurationResponse:))
                .observe(on: MainScheduler.asyncInstance)
                .flatMap(startMoviesListScene(configuration:))
                .catch { error in
                    loading.showError(error.localizedDescription)
                    return .never()
                }
        default:
            return .never()
        }
    }

    private func startMoviesListScene(configuration: Configuration) -> Observable<Void> {
        return coordinate(to: MoviesListCoordinator(window: window, configuration: configuration))
    }
}
