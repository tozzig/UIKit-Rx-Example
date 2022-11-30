//
//  ConfigurationService.swift
//  Movies
//
//  Created by onton on 27.11.2022.
//

import RxSwift

protocol ConfigurationServiceProtocol {
    func getConfiguration() -> Single<ConfigurationResponse>
}

final class ConfigurationService: ConfigurationServiceProtocol {
    private let networkProvider: NetworkProviderProtocol

    init(networkProvider: NetworkProviderProtocol) {
        self.networkProvider = networkProvider
    }

    func getConfiguration() -> Single<ConfigurationResponse> {
        networkProvider.request(request: ConfigurationAPI.getConfiguration)
    }
}
