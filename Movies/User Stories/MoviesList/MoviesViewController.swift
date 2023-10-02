//
//  MoviesViewController.swift
//  Movies
//
//  Created by onton on 22.11.2022.
//

import RxCocoa
import RxDataSources
import RxSwift

final class MoviesViewController: UIViewController {
    private let viewModel: MoviesViewModelProtocol
    private let disposeBag = DisposeBag()

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var errorLabel: UILabel!

    init(viewModel: MoviesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupTableView()
    }
}

private extension MoviesViewController {
    func setupTableView() {
        tableView.register(R.nib.movieListCell)
        tableView.register(R.nib.noResultsCell)
        tableView.register(R.nib.loadingCell)
        tableView.tableFooterView = UIView()
    }

    func setupBindings() {
        title = viewModel.title

        typealias DataSource = RxTableViewSectionedReloadDataSource<MoviesSection>
        let eventsDataSource = DataSource { [weak self] _, tableView, indexPath, item in
            guard let self else {
                return UITableViewCell()
            }
            let cell: UITableViewCell?
            switch item {
            case .movie(let item):
                let movieCell = tableView.dequeueReusableCell(
                    withIdentifier: R.reuseIdentifier.movieListCell,
                    for: indexPath
                )
                movieCell?.updateViewModel(self.viewModel.movieCellViewModel(for: item))
                cell = movieCell
            case .noResults:
                cell = tableView.dequeueReusableCell(
                    withIdentifier: R.reuseIdentifier.noResultsCell,
                    for: indexPath
                )
            case .loading:
                cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.loadingCell, for: indexPath)
            }
            return cell ?? UITableViewCell()
        }

        tableView.rx.modelSelected(MoviesListCellType.self)
            .bind(to: viewModel.selectedItem)
            .disposed(by: disposeBag)

        viewModel.sections
            .compactMap { $0 }
            .drive(tableView.rx.items(dataSource: eventsDataSource))
            .disposed(by: disposeBag)

        viewModel.sections
            .map { $0 == nil }
            .drive(tableView.rx.isHidden)
            .disposed(by: disposeBag)

        tableView.rx.prefetchRows
            .bind(to: viewModel.prefetchRows)
            .disposed(by: disposeBag)

        viewModel.error
            .drive(errorLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.error
            .map { $0 == nil }
            .drive(errorLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
