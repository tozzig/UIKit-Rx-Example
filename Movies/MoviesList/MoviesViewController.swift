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

    private let viewModel: MoviesViewModel

    private let disposeBag = DisposeBag()

    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(R.nib.movieListCell)
        tableView.register(R.nib.noResultsCell)
        tableView.tableFooterView = UIView()
        setupBindings()
    }

    private func setupBindings() {
        let eventsDataSource = RxTableViewSectionedReloadDataSource<Section>(
             configureCell: { [unowned self] _, tableView, indexPath, item in
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
                 }
                 return cell ?? UITableViewCell()
            }
        )
        disposeBag.insert(
            tableView.rx.modelSelected(MoviesListCellType.self).bind(to: viewModel.input.selectedItem),
            viewModel.output.title.drive(rx.title),
            viewModel.output.sections.drive(tableView.rx.items(dataSource: eventsDataSource))
        )
    }
}

