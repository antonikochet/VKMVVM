//
//  UserResponse.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 16.01.2022.
//

import Foundation

struct UserResponseWrapper: Decodable {
    let response: [UserResponse]
}

struct UserResponse: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let deactivated: String?
    let isClosed: Bool?
    let canAccessClosed: Bool?
    
    //MARK: - option property
    let screenName: String?
    let sex: Int?
    let birthdayData: String?
    let HomeTown: String?
    let status: String?
    let photoUrl: String?
    let followersCount: Int?
    let universityName: String?
    let online: Int?
    let onlineMobile: Int?
    let lastSeen: LastSeen?
    let city: City?
    
    var isOnline: Bool {
        return online == 1
    }
    
    var isOnlineMobile: Bool {
        return onlineMobile == 1
    }
    
    var Sex: String {
        switch sex {
            case 1: return "Женский"
            case 2: return "Мужской"
            default: return "Не указан"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, deactivated
        case firstName = "first_name"
        case lastName = "last_name"
        case isClosed = "is_closed"
        case canAccessClosed = "can_access_closed"
        
        //MARK: - option property coding keys
        case sex, status, online, city
        case screenName = "screen_name"
        case birthdayData = "bdate"
        case HomeTown = "home_town"
        case photoUrl = "photo_100"
        case followersCount = "followers_count"
        case universityName = "university_name"
        case onlineMobile = "online_mobile"
        case lastSeen = "last_seen"
    }
}

struct LastSeen: Decodable {
    let time: Int
    let platform: Int
}

struct City: Decodable {
    let id: Int
    let title: String
}
