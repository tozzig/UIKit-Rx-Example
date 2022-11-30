//
//  AppDelegate.swift
//  Movies
//
//  Created by onton on 22.11.2022.
//

import RxSwift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var disposeBag = DisposeBag()

    private var appCoordinator: AppCoordinator!

    private let dependencies = DependencyContainer()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow()
        self.window = window
        appCoordinator = AppCoordinator(window: window, dependenciesProvider: dependencies)
        goToScene(.moviesList)
        return true
    }

    func goToScene(_ scene: Scene) {
        disposeBag = DisposeBag()
        appCoordinator.start(nextScene: .moviesList, animated: false)
            .drive()
            .disposed(by: disposeBag)
    }
}
