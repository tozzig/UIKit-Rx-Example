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
        typealias DataSource = RxTableViewSectionedReloadDataSource<Section>
        let eventsDataSource = DataSource { [unowned self] _, tableView, indexPath, item in
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
        disposeBag.insert(
            tableView.rx.modelSelected(MoviesListCellType.self).bind(to: viewModel.input.selectedItem),
            viewModel.output.title.drive(rx.title),
            viewModel.output.sections.drive(tableView.rx.items(dataSource: eventsDataSource)),
            tableView.rx.prefetchRows.bind(to: viewModel.input.prefetchRows)
        )
    }
}
