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

private enum Constants {
    static let missingPosterSizers = "Configuration is missing poster sizes"
    static let wrongPosterSizers = "Configuration has wrong poster sizes"
}

final class ImageUrlBuilder {
    enum ImageUrlError: String, LocalizedError {
        case missingPosterSizers
        case wrongPosterSizers

        var errorDescription: String? {
            switch self {
            case .missingPosterSizers:
                return Constants.missingPosterSizers
            case .wrongPosterSizers:
                return Constants.wrongPosterSizers
            }
        }
    }

    private static let preferredThumbnailSizes = ["w500", "w780", "original"]
    private static let preferredPosterSizes = ["original", "w780", "w500"]

    private let configuration: ConfigurationProtocol
    private let posterSize: String
    private let thumbnailImageSize: String

    init(configuration: ConfigurationProtocol) throws {
        guard !configuration.posterSizes.isEmpty else {
            throw ImageUrlError.missingPosterSizers
        }
        self.configuration = configuration

        let thumbnailImageSize = Self.preferredThumbnailSizes.first { preferredSize in
            configuration.posterSizes.contains(preferredSize)
        }

        let posterSize = Self.preferredPosterSizes.first { preferredSize in
            configuration.posterSizes.contains(preferredSize)
        }
        if let posterSize, let thumbnailImageSize {
            self.posterSize = posterSize
            self.thumbnailImageSize = thumbnailImageSize
        } else {
            throw ImageUrlError.wrongPosterSizers
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
