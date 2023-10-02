//
//  RxExtensions.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import RxCocoa
import RxSwift

extension ObservableConvertibleType {
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        asDriver { _ in .empty() }
    }
}
