//
//  MoviesSection.swift
//  Movies
//
//  Created by onton on 30.11.2022.
//

import RxDataSources

struct MoviesSection {
    var items: [Item]
}

extension MoviesSection: SectionModelType {
    typealias Item = MoviesListCellType

    init(original: MoviesSection, items: [Item]) {
        self = original
        self.items = items
    }
}
