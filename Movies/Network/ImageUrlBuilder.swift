//
//  ImageUrlBuilder.swift
//  Movies
//
//  Created by onton on 24.11.2022.
//

import Foundation

protocol ImageUrlBuilderProtocol {
    func posterUrl(for movie: MovieDetailItem) -> URL?
    func thumbnailImageURL(for movie: MovieListItem) -> URL?
}

final class ImageUrlBuilder {
    private static let preferredThumbnailSizes = ["w500", "w780", "original"]
    private static let preferredPosterSizes = ["original", "w780", "w500"]

    private let configuration: Configuration
    private let posterSize: String
    private let thumbnailImageSize: String

    init?(configuration: Configuration) {
        guard !configuration.posterSizes.isEmpty else {
            return nil
        }
        self.configuration = configuration

        let thumbnailImageSize = ImageUrlBuilder.preferredThumbnailSizes.first(where: { preferredSize in
            configuration.posterSizes.contains(preferredSize)
        })

        let posterSize = ImageUrlBuilder.preferredPosterSizes.first(where: { preferredSize in
            configuration.posterSizes.contains(preferredSize)
        })
        if let posterSize, let thumbnailImageSize {
            self.posterSize = posterSize
            self.thumbnailImageSize = thumbnailImageSize
        } else {
            return nil
        }
    }
}

extension ImageUrlBuilder: ImageUrlBuilderProtocol {
    func posterUrl(for movie: MovieDetailItem) -> URL? {
        configuration.baseURL.appendingPathComponent(posterSize + movie.posterPath!)
    }

    func thumbnailImageURL(for movie: MovieListItem) -> URL? {
        configuration.baseURL.appendingPathComponent(thumbnailImageSize + movie.posterPath!)
    }
}
