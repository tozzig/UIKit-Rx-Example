//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by onton on 25.11.2022.
//

import RxCocoa
import RxSwift

final class MovieDetailViewController: UIViewController {
    private let viewModel: MovieDetailViewModelProtocol
    private let disposeBag = DisposeBag()

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var releaseYearLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var errorLabel: UILabel!

    init(viewModel: MovieDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
}

private extension MovieDetailViewController {
    func setupBindings() {
        viewModel.isErrorVisible
            .drive(scrollView.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.releaseYear
            .drive(releaseYearLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.overview
            .drive(overviewLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.title
            .drive(rx.title)
            .disposed(by: disposeBag)

        viewModel.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.imageURL
            .drive { [weak self] url in
                self?.posterImageView.kf.setImage(with: url)
            }
            .disposed(by: disposeBag)

        viewModel.errorText
            .drive(errorLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.isErrorVisible
            .map(!)
            .drive(errorLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
