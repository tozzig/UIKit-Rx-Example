//
//  DateFormatters.swift
//  Movies
//
//  Created by onton on 30.11.2022.
//

import Foundation

enum DateFormatters {
    static let full = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        return formatter
    }()

    static let years = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        return formatter
    }()

    static func convertStringFromFullDateToYears(_ dateString: String) -> String? {
        guard let date = full.date(from: dateString) else {
            return nil
        }
        return years.string(from: date)
    }
}
