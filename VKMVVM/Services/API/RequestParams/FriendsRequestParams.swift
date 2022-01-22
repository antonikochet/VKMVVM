//
//  FriendsRequestParams.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 19.01.2022.
//

import Foundation

enum FriendsRequestParams: String {
    case userId = "user_id"
    case order
    case count
    case offset
    case fields
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
