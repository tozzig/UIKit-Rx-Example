//
//  BaseCoordinator.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import RxSwift

class BaseCoordinator<ResultType> {
    typealias CoordinationResult = ResultType

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
        params: [String: Any]? = nil,
        animated: Bool = true
    ) -> Observable<T> {
        store(coordinator: coordinator)
        return coordinator.start(nextScene: nextScene, params: params, animated: animated)
            .do { [weak self] _ in
                self?.free(coordinator: coordinator)
            }
    }

    func start(
        nextScene: Scene? = nil,
        params: [String: Any]? = nil,
        animated: Bool = true
    ) -> Observable<ResultType> {
        fatalError("Start method should be implemented.")
    }
}
