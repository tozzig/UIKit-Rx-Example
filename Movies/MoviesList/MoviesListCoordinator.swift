//
//  MoviesListCoordinator.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import RxSwift

class MoviesListCoordinator: BaseCoordinator<Void> {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
        super.init()
    }

    override func start(nextScene: Scene?, params: [String : Any]?, animation: Bool = true) -> Observable<Void> {

        let view = R.storyboard.main.moviesList()!
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.navigationBar.prefersLargeTitles = true

//        view.viewModel.output.selectedCity
//            .subscribe(onNext: { [weak self] cityName in
//                self?.startWeatherDetail(in: navigationController, with: cityName)
//            }).disposed(by: disposeBag)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        return .never()
    }

    private func startWeatherDetail(in navigationController: UINavigationController, with cityName: String) {
//        coordinate(
//            to: WeatherDetailCoordinator(navigationController: navigationController),
//            params: ["cityName": cityName]
//        ).subscribe().disposed(by: disposeBag)
    }
}
