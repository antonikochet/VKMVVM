//
//  FriendsRequestParams.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 19.01.2022.
//

import Foundation

struct FriendsRequestParams: RequestParamsProtocol {
    let userId: String?
    let order: FriendsRequestOrderParams?
    let count: Int?
    let offset: Int?
    let fields: [FriendsRequestFieldsParams]?
    
    func generateParametrsForRequest() -> Parametrs {
        var parametrs: Parametrs = [:]
        if let fields = fields {
            parametrs[NameRequestParams.fields.rawValue] = FriendsRequestFieldsParams.params(fields)
        }
        if let userId = userId {
            parametrs[NameRequestParams.userId.rawValue] = userId
        }
        if let order = order {
            parametrs[NameRequestParams.order.rawValue] = order.rawValue
        }
        return parametrs
    }
    
    private enum NameRequestParams: String {
        case userId = "user_id"
        case order
        case count
        case offset
        case fields
    }
}

enum FriendsRequestOrderParams: String {
    case hints
    case random
    case name
}

enum FriendsRequestFieldsParams: String, CaseIterable {
    case photo100 = "photo_100"
    case city
    case online
    case has_mobile
    
    static func params(_ array: [FriendsRequestFieldsParams]) -> String {
        return array.map { $0.rawValue }.joined(separator: ",")
    }
    
    static var allParams = params(Self.allCases)
}
