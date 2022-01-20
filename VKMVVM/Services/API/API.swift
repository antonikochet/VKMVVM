//
//  API.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 15.12.2021.
//

import Foundation

struct API {
    static let scheme = "https"
    static let host = "api.vk.com"
    static let version = "5.131"
}

enum APIMethods: String {
    case getNewsFeed = "newsfeed.get"
    case getUsers = "users.get"
    case getFriends = "friends.get"
    
    var path: String {
        return "/method/" + self.rawValue
    }
}
