//
//  NewsFeedRequestParams.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 21.12.2021.
//

import Foundation

enum NewsFeedFiltersParams: String {
    case phone, post

    static func params(_ array: [NewsFeedFiltersParams]) -> String {
        return array.map { $0.rawValue }.joined(separator: ",")
    }
}

struct NewsFeedParams: RequestParamsProtocol {
    let filters: [NewsFeedFiltersParams]
    let startFrom: String?
    
    func generateParametrsForRequest() -> Parametrs {
        var params: Parametrs = [:]
        params[NameParams.filters.rawValue] = NewsFeedFiltersParams.params(filters)
        if let startFrom = startFrom {
            params[NameParams.startFrom.rawValue] = startFrom
        }
        return params
    }
    
    private enum NameParams: String {
        case filters
        case startFrom = "start_from"
    }
}
