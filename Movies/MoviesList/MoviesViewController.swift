//
//  MoviesViewController.swift
//  Movies
//
//  Created by onton on 22.11.2022.
//

import RxCocoa
import RxSwift
import RxDataSources

class MoviesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    let viewModel = MoviesViewModel()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        setupBindings()
    }

    private func setupBindings() {
        let eventsDataSource = RxTableViewSectionedReloadDataSource<Section>(
             configureCell: { [unowned self] _, tableView, indexPath, item in
                 switch item {
                 case .movie(let item):
                     let cell = tableView.dequeueReusableCell(
                        withIdentifier: R.reuseIdentifier.movieListCell,
                        for: indexPath
                     )
                     cell?.movieTitleLabel.text = item.originalTitle
                     cell?.releaseYearLabel.text = item.releaseDate
                     return cell ?? UITableViewCell()
                 case .noResults:
                     return tableView.dequeueReusableCell(
                        withIdentifier: R.reuseIdentifier.noResultsCell,
                        for: indexPath
                     ) ?? UITableViewCell()
                 }
            }
        )
        disposeBag.insert(
            tableView.rx.modelSelected(MoviesListCellType.self).bind(to: viewModel.input.selectedItem),
            viewModel.output.title.drive(rx.title),
            viewModel.output.sections.drive(tableView.rx.items(dataSource: eventsDataSource))
        )
    }
}

