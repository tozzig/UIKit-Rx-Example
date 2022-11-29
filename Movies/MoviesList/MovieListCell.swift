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
        disposeBag.insert(
            viewModel.output.releaseYear.drive(releaseYearLabel.rx.text),
            viewModel.output.title.drive(movieTitleLabel.rx.text),
            viewModel.output.imageURL.drive { [unowned self] url in
                posterImageView.kf.setImage(with: url)
            }
        )
    }
}
