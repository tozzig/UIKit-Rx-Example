//
//  BaseCoordinator.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import RxCocoa
import RxSwift

class BaseCoordinator<ResultType> {
    let disposeBag = DisposeBag()
    private let identifier = UUID()
    private var childCoordinators = [UUID: Any]()

    private func store<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    private func free<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }

    func coordinate<T>(
        to coordinator: BaseCoordinator<T>,
        nextScene: Scene? = nil,
        animated: Bool = true
    ) -> Driver<T> {
        store(coordinator: coordinator)
        return coordinator.start(nextScene: nextScene, animated: animated)
            .do { [weak self, weak coordinator] _ in
                if let coordinator {
                    self?.free(coordinator: coordinator)
                }
            }
    }

    func start(nextScene: Scene? = nil, animated: Bool = true) -> Driver<ResultType> {
        fatalError("Start method should be implemented.")
    }
}
