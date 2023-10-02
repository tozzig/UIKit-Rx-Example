//
//  MoviesViewModel.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import RxCocoa
import RxDataSources
import RxSwift

typealias MoviesViewModelDependencies = ImageUrlBuilderProvider & MoviesServiceProvider

private enum Constants {
    static let movies = "Movies"
    static let defaultPagesCount = 1
    static let startingPageNumber = 1
}

protocol MoviesViewModelProtocol {
    var title: String { get }
    var sections: Driver<[MoviesSection]?> { get }
    var error: Driver<String?> { get }
    var selectedMovieId: Observable<Int> { get }

    var selectedItem: AnyObserver<MoviesListCellType> { get }
    var prefetchRows: AnyObserver<[IndexPath]> { get }

    func movieCellViewModel(for item: MovieListItem) -> MovieListCellViewModelProtocol
}

final class MoviesViewModel: MoviesViewModelProtocol {
    let title = Constants.movies
    let sections: Driver<[MoviesSection]?>
    let error: Driver<String?>
    let selectedMovieId: Observable<Int>
    let selectedItem: AnyObserver<MoviesListCellType>
    let prefetchRows: AnyObserver<[IndexPath]>

    private let moviesService: Single<MoviesServiceProtocol>
    private let imageUrlBuilder: Single<ImageUrlBuilderProtocol>
    private let disposeBag = DisposeBag()

    convenience init(dependencies: MoviesViewModelDependencies) {
        self.init(moviesService: dependencies.moviesService, imageUrlBuilder: dependencies.imageUrlBuilder)
    }

    init(moviesService: Single<MoviesServiceProtocol>, imageUrlBuilder: Single<ImageUrlBuilderProtocol>) {
        self.moviesService = moviesService
        self.imageUrlBuilder = imageUrlBuilder

        let loadNextItemTrigger = PublishSubject<Void>()

        let initialResponse = moviesService.flatMap { $0.moviesList() }

        let pagesCount = initialResponse.map { $0.totalPages ?? Constants.defaultPagesCount }

        let currentPage = loadNextItemTrigger.withLatestFrom(pagesCount)
            .scan(Constants.startingPageNumber) { pageNumber, pagesCount -> Int? in
                guard let pageNumber, pagesCount > pageNumber else {
                    return nil
                }
                return pageNumber + 1
            }
            .startWith(Constants.startingPageNumber)

        let morePages = currentPage.compactMap { $0 }
            .flatMap { page in
                moviesService.flatMap { $0.moviesList(page: page) }
            }
            .compactMap(\.results)
            .scan([], accumulator: +)

        let sectionItems = morePages
            .map { items -> [MoviesListCellType] in
                items.isEmpty ? [.noResults] : items.map { .movie($0) }
            }
            .withLatestFrom(currentPage) { ($0, $1) }
            .map { cells, page in
                var sections = [MoviesSection(items: cells)]
                if page != nil {
                    sections.append(MoviesSection(items: [.loading]))
                }
                return sections
            }

        let selectedModelSubject = PublishSubject<MoviesListCellType>()
        let prefetchRowsSubject = PublishSubject<[IndexPath]>()

        prefetchRowsSubject
            .withLatestFrom(sectionItems) { ($0, $1) }
            .filter { indexPaths, sections in
                guard let lastSectionIndex = sections.lastIndex(where: { $0.items.contains(.loading) }) else {
                    return false
                }
                return indexPaths.map(\.section).contains(lastSectionIndex)
            }
            .map { _ in () }
            .bind(to: loadNextItemTrigger)
            .disposed(by: disposeBag)

        sections = sectionItems
            .map(Optional.init)
            .asDriver(onErrorJustReturn: nil)
        error = sectionItems
            .map { _ in nil }
            .asDriver { .just($0.localizedDescription) }
        selectedMovieId = selectedModelSubject.compactMap { item -> Int? in
            switch item {
            case .noResults, .loading:
                return nil
            case .movie(let movie):
                return movie.id
            }
        }

        selectedItem = selectedModelSubject.asObserver()
        prefetchRows = prefetchRowsSubject.asObserver()
    }
}

extension MoviesViewModel {
    func movieCellViewModel(for item: MovieListItem) -> MovieListCellViewModelProtocol {
        MovieListCellViewModel(movieListItem: item, imageUrlBuilder: imageUrlBuilder)
    }
}
