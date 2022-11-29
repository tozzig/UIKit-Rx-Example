//
//  AppDelegate.swift
//  Movies
//
//  Created by onton on 22.11.2022.
//

import UIKit
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var disposeBag = DisposeBag()
    
    private var appCoordinator: AppCoordinator!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow()
        self.window = window
        appCoordinator = AppCoordinator(window: window, configurationService: ConfigurationService())
        
        goToScene(.moviesList)
        return true
    }

    func goToScene(_ scene: Scene, params: [String: AnyObject]? = nil) {
        disposeBag = DisposeBag()
        appCoordinator.start(nextScene: .moviesList, params: params, animated: false)
            .subscribe()
            .disposed(by: disposeBag)
    }
}

