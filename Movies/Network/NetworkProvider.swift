//
//  NetworkProvider.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import Alamofire
import RxSwift

final class NetworkProvider {
    
    static let shared = NetworkProvider()
    
    private let requestTimeout: TimeInterval = 60
    
    private(set) lazy var session: Session = {
        let configuartion = URLSessionConfiguration.default
        configuartion.timeoutIntervalForRequest = requestTimeout
        return Session(configuration: .default)
    }()
    
    private var disposeBag = DisposeBag()
    
    private init() { }
    
    func request(request: RequestProtocol) -> DataRequest {
        session.request(
            request.baseURL.appendingPathComponent(request.path),
            method: request.method,
            parameters: request.parameters,
            encoding: request.paramsEncoding,
            headers: request.headers
        )
    }
}
