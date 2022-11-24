//
//  MoviesViewModel.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import RxCocoa
import RxSwift
import RxDataSources

class MoviesViewModel {

    let input: Input
    let output: Output

    private let bag = DisposeBag()

    init() {
        let service = MoviesService()
        let sections = service.moviesList()
            .map { response in
                return [Section(items: response.value?.results.map { .movie($0) } ?? [.noResults])]
            }
            .asDriverOnErrorJustComplete()
        let selectedModelSubject = PublishSubject<MoviesListCellType>()
        let selectedMovieId = selectedModelSubject.compactMap { item -> Int? in
            switch item {
            case .noResults:
                return nil
            case .movie(let movie):
                return movie.id
            }
        }
        input = Input(
            selectedItem: selectedModelSubject.asObserver()
        )
        output = Output(
            title: .just("Movies"),
            sections: sections,
            selectedMovieId: selectedMovieId
        )
    }

}

enum MoviesListCellType {
    case movie(MovieListItem)
    case noResults
}

extension MoviesViewModel {
    struct Input {
        let selectedItem: AnyObserver<MoviesListCellType>
    }

    struct Output {
        let title: Driver<String>
        let sections: Driver<[Section]>
        let selectedMovieId: Observable<Int>
    }
}

struct Section {
    var items: [Item]
}

extension Section: SectionModelType {
    typealias Item = MoviesListCellType

    init(original: Section, items: [Item]) {
        self = original
        self.items = items
    }
}
