//
//  RxExtensions.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import RxCocoa
import RxSwift

extension ObservableType {
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        asDriver { _ in .empty() }
    }
}

extension Single {
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        asObservable().asDriverOnErrorJustComplete()
    }
}
