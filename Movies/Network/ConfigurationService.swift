//
//  ConfigurationService.swift
//  Movies
//
//  Created by onton on 27.11.2022.
//

import RxSwift

final class ConfigurationService {
    func getConfiguration() -> Single<ConfigurationResponse> {
        return NetworkProvider.shared.rx.request(request: ConfigurationAPI.getConfiguration)
    }
}
