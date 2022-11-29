//
//  MovieListCell.swift
//  Movies
//
//  Created by onton on 23.11.2022.
//

import RxCocoa
import RxSwift
import Kingfisher

class MovieListCell: UITableViewCell {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var releaseYearLabel: UILabel!

    private var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }

    func updateViewModel(_ viewModel: MovieListCellViewModelProtocol) {
        disposeBag = DisposeBag()
        disposeBag.insert(
            viewModel.output.releaseYear.drive(releaseYearLabel.rx.text),
            viewModel.output.title.drive(movieTitleLabel.rx.text),
            viewModel.output.imageURL.drive(onNext: { [unowned self] url in
                posterImageView.kf.setImage(with: url)
            })
        )
    }
}

protocol MovieListCellViewModelProtocol {
    var output: MovieListCellViewModelOutputProtocol { get }
}

protocol MovieListCellViewModelOutputProtocol {
    var imageURL: Driver<URL?> { get }
    var title: Driver<String> { get }
    var releaseYear: Driver<String> { get }
}

final class MovieListCellViewModel: MovieListCellViewModelProtocol {
    let output: MovieListCellViewModelOutputProtocol

    init(movieListItem: MovieListItem, moviesService: MoviesServiceProtocol, imageUrlBuilder: ImageUrlBuilderProtocol) {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        let releaseYear: Driver<String>
        if let date = formatter.date(from: movieListItem.releaseDate) {
            formatter.dateFormat = "YYYY"
            releaseYear = .just(formatter.string(from: date))
        } else {
            releaseYear = .just("")
        }
        output = Output(
            imageURL: .just(imageUrlBuilder.thumbnailImageURL(for: movieListItem)),
            title: .just(movieListItem.originalTitle),
            releaseYear: releaseYear
        )
    }
}

extension MovieListCellViewModel {
    struct Output: MovieListCellViewModelOutputProtocol {
        let imageURL: Driver<URL?>
        let title: Driver<String>
        let releaseYear: Driver<String>
    }
}
