//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by onton on 25.11.2022.
//

import RxCocoa
import RxSwift

final class MovieDetailViewController: UIViewController {
    
    @IBOutlet private weak var releaseYearLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var overviewLabel: UILabel!

    private let viewModel: MovieDetailViewModel

    private let disposeBag = DisposeBag()

    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindObservables()
    }

    func bindObservables() {
        guard viewIfLoaded != nil else {
            return
        }
        disposeBag.insert(
            viewModel.output.releaseYear.drive(releaseYearLabel.rx.text),
            viewModel.output.overview.drive(overviewLabel.rx.text),
            viewModel.output.title.drive(rx.title),
            viewModel.output.title.drive(titleLabel.rx.text),
            viewModel.output.imageURL.drive(onNext: { [unowned self] url in
                posterImageView.kf.setImage(with: url)
            })
        )
    }
}
