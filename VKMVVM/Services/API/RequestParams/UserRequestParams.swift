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

enum UserRequestFieldsParams: String {
    case birthdayData = "bdate"
    case screenName = "screen_name"
    case HomeTown = "home_town"
    case photo100 = "photo_100"
    case followersCount = "followers_count"
    case sex, education
    
    static func params(_ array: UserRequestFieldsParams...) -> String {
        return array.map { $0.rawValue }.joined(separator: ",")
    }
}
