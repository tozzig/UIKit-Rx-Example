//
//  MovieListCell.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import Kingfisher
import RxCocoa
import RxSwift

final class MovieListCell: UITableViewCell {
    private var disposeBag = DisposeBag()

    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var releaseYearLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }

    func updateViewModel(_ viewModel: MovieListCellViewModelProtocol) {
        disposeBag = DisposeBag()
        releaseYearLabel.text = viewModel.releaseYear

        movieTitleLabel.text = viewModel.title

        viewModel.imageURL
            .drive { [weak self] url in
                self?.posterImageView.kf.setImage(with: url)
            }
            .disposed(by: disposeBag)
    }
}
