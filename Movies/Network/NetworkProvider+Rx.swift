//
//  NetworkProvider+Rx.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import Alamofire
import RxAlamofire
import RxSwift

extension NetworkProvider: ReactiveCompatible {}

extension Reactive where Base: NetworkProvider {
    func requestBase<T>(request: RequestProtocol, statusCodes: Range<Int> = 200..<400, transform: @escaping (Data) throws -> T) -> Observable<NetworkResponse<T>> {
        let response: Observable<Data> = base.request(request: request, statusCodes: statusCodes).rx.data()
        return response
            .map { data -> NetworkResponse<T> in
                do {
                    let value = try transform(data)
                    return .success(value)
                } catch {
                    return .failure(.parsingError(error))
                }
            }
            .catch { responseError in
                return .just(.failure(.networkError(responseError)))
            }
            .subscribe(on: Scheduler.io)
            .observe(on: Scheduler.io)
    }
    
    func request<T: Decodable>(request: RequestProtocol) -> Observable<NetworkResponse<T>> {
        requestBase(request: request, transform: {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: $0)
        })
    }
}

class Scheduler {
    static var io: ImmediateSchedulerType = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 4
        operationQueue.qualityOfService = .userInitiated
        operationQueue.name = "IO"
        return OperationQueueScheduler(operationQueue: operationQueue)
    }()
}
