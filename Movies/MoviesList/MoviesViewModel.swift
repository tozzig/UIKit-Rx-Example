//
//  MoviesViewModel.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import RxCocoa
import RxSwift
import RxDataSources

protocol MoviesViewModelProtocol {
    var input: MoviesViewModelInputProtocol { get }
    var output: MoviesViewModelOutputProtocol { get }

    func movieCellViewModel(for item: MovieListItem) -> MovieListCellViewModelProtocol
}

protocol MoviesViewModelInputProtocol {
    var selectedItem: AnyObserver<MoviesListCellType> { get }
    var prefetchRows: AnyObserver<[IndexPath]> { get }
}

protocol MoviesViewModelOutputProtocol {
    var title: Driver<String> { get }
    var sections: Driver<[Section]> { get }
    var selectedMovieId: Observable<Int> { get }
}

final class MoviesViewModel: MoviesViewModelProtocol {

    let input: MoviesViewModelInputProtocol
    let output: MoviesViewModelOutputProtocol

    private let bag = DisposeBag()

    private let moviesService: MoviesServiceProtocol
    private let imageUrlBuilder: ImageUrlBuilderProtocol

    init(moviesService: MoviesServiceProtocol, imageUrlBuilder: ImageUrlBuilderProtocol) {
        self.moviesService = moviesService
        self.imageUrlBuilder = imageUrlBuilder
        let loadNextItemTrigger = PublishSubject<Void>()

        let initialResponse = moviesService.moviesList()

        let pagesCount = initialResponse.map { $0.totalPages ?? 1 }

        let currentPage = loadNextItemTrigger.withLatestFrom(pagesCount)
            .scan(1) { pageNumber, pagesCount -> Int? in
                guard let pageNumber, pagesCount > pageNumber else {
                    return nil
                }
                return pageNumber + 1
            }
            .startWith(1)

        let morePages = currentPage.compactMap { $0 }
            .flatMap { moviesService.moviesList(page: $0).compactMap(\.results) }
            .scan([], accumulator: +)

        let sectionItems = morePages
            .map { items -> [MoviesListCellType] in
                return items.isEmpty ? [.noResults] : items.map { MoviesListCellType.movie($0) }
            }
            .withLatestFrom(currentPage) { ($0, $1) }
            .map { cells, page in
                var sections = [Section(items: cells)]
                if page != nil {
                    sections.append(Section(items: [.loading]))
                }
                return sections
            }
            .asDriver(onErrorJustReturn: [Section(items: [.noResults])])

        let selectedModelSubject = PublishSubject<MoviesListCellType>()
        let selectedMovieId = selectedModelSubject.compactMap { item -> Int? in
            switch item {
            case .noResults, .loading:
                return nil
            case .movie(let movie):
                return movie.id
            }
        }

        let prefetchRows = PublishSubject<[IndexPath]>()

        prefetchRows
            .withLatestFrom(sectionItems) { ($0, $1) }
            .filter { indexPaths, sections in
                guard let lastSectionIndex = sections.lastIndex(where: { $0.items.contains(.loading) }) else {
                    return false
                }
                return indexPaths.map(\.section).contains(lastSectionIndex)
            }
            .map { _ in () }
            .bind(to: loadNextItemTrigger)
            .disposed(by: bag)

        input = Input(
            selectedItem: selectedModelSubject.asObserver(),
            prefetchRows: prefetchRows.asObserver()
        )
        output = Output(
            title: .just("Movies"),
            sections: sectionItems,
            selectedMovieId: selectedMovieId
        )
    }

}

extension MoviesViewModel {
    func movieCellViewModel(for item: MovieListItem) -> MovieListCellViewModelProtocol {
        MovieListCellViewModel(movieListItem: item, moviesService: moviesService, imageUrlBuilder: imageUrlBuilder)
    }
}

enum MoviesListCellType: Equatable {
    case movie(MovieListItem)
    case noResults
    case loading
}

extension MoviesViewModel {
    struct Input: MoviesViewModelInputProtocol {
        let selectedItem: AnyObserver<MoviesListCellType>
        let prefetchRows: AnyObserver<[IndexPath]>
    }

    struct Output: MoviesViewModelOutputProtocol {
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
