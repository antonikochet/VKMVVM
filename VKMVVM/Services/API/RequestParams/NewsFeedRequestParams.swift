//
//  NewsFeedRequestParams.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 21.12.2021.
//

import Foundation

enum NewsFeedFiltersParams: String {
    case phone, post

    static func params(_ array: NewsFeedFiltersParams...) -> String {
        return array.map { $0.rawValue }.joined(separator: ",")
    }
}

enum NewsFeedParams: String {
    case filters
    case startFrom = "start_from"
}
