//
//  UserRequestParams.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 16.01.2022.
//

import Foundation

enum UserRequestParams: String {
    case userIds = "user_ids"
    case fields
}

enum UsersGetFollowersRequestParams: String {
    case userId = "user_id"
    case fields
}

enum UserRequestFieldsParams: String, CaseIterable {
    case birthdayData = "bdate"
    case screenName = "screen_name"
    case HomeTown = "home_town"
    case photo100 = "photo_100"
    case followersCount = "followers_count"
    case lastSeen = "last_seen"
    case sex, education, online
    
    static func params(_ array: [Self]) -> String {
        return array.map { $0.rawValue }.joined(separator: ",")
    }
    
    static let allFieldsParams: String = params(Self.allCases)
}
