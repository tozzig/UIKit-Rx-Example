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
        return base.request(request: request).rx.decodable(decoder: decoder)
            .asSingle()
            .subscribe(on: Scheduler.io)
            .observe(on: Scheduler.io)
    }
}

private class Scheduler {
    static var io: ImmediateSchedulerType = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 4
        operationQueue.qualityOfService = .userInitiated
        operationQueue.name = "IO"
        return OperationQueueScheduler(operationQueue: operationQueue)
    }()
}
