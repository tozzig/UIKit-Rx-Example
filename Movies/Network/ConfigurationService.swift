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
    func getConfiguration() -> Single<ConfigurationResponse> {
        NetworkProvider.shared.rx.request(request: ConfigurationAPI.getConfiguration)
    }
}
