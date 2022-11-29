//
//  NetworkProvider+Rx.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import RxAlamofire
import RxSwift

extension NetworkProvider: ReactiveCompatible {}

extension Reactive where Base: NetworkProvider {
    func request<T: Decodable>(request: RequestProtocol) -> Single<T> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return base.request(request: request).rx
            .decodable(decoder: decoder)
            .asSingle()
            .subscribe(on: Scheduler.network)
            .observe(on: Scheduler.network)
    }
}

private enum Scheduler {
    static var network: ImmediateSchedulerType = {
        let operationQueue = OperationQueue()
        let maxConcurrentOperationCount = 4
        operationQueue.maxConcurrentOperationCount = maxConcurrentOperationCount
        operationQueue.qualityOfService = .userInitiated
        operationQueue.name = "IO"
        return OperationQueueScheduler(operationQueue: operationQueue)
    }()
}
