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

    private let moviesService: MoviesService
    private let imageUrlBuilder: ImageUrlBuilder

    init(moviesService: MoviesService, imageUrlBuilder: ImageUrlBuilder) {
        self.moviesService = moviesService
        self.imageUrlBuilder = imageUrlBuilder
        let sections = moviesService.moviesList()
            .map { response in
                return [Section(items: response.value?.results?.map { .movie($0) } ?? [.noResults])]
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

        let loadNextItemTrigger = PublishSubject<Void>()

//        let x = Observable.of(1, 2, 3)
//        Observable.scan(<#T##self: Observable<_>##Observable<_>#>)
        input = Input(
            selectedItem: selectedModelSubject.asObserver(),
            shouldLoadNextItem: loadNextItemTrigger.asObserver()
        )
        output = Output(
            title: .just("Movies"),
            sections: sections,
            selectedMovieId: selectedMovieId
        )
    }

}

extension MoviesViewModel {
    func movieCellViewModel(for item: MovieListItem) -> MovieListCellViewModel {
        .init(movieListItem: item, moviesService: moviesService, imageUrlBuilder: imageUrlBuilder)
    }
}

enum MoviesListCellType {
    case movie(MovieListItem)
    case noResults
}

extension MoviesViewModel {
    struct Input {
        let selectedItem: AnyObserver<MoviesListCellType>
        let shouldLoadNextItem: AnyObserver<Void>
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
