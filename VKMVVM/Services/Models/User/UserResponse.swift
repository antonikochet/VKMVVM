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
    @DecodableBool var isClosed: Bool
    @DecodableBool var canAccessClosed: Bool
    
    //MARK: - option property
    let screenName: String?
    let sex: Int?
    let birthdayData: String?
    let homeTown: String?
    let status: String?
    let photoUrl: String?
    let followersCount: Int?
    let universityName: String?
    let online: Int?
    let onlineMobile: Int?
    let lastSeen: LastSeen?
    let city: City?
    let relation: RelationUser?
    let personal: PersonalInfo?
    let relatives: [RelativesInfo]?
    
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
        case sex, status, online, city, relation, personal, relatives
        case screenName = "screen_name"
        case birthdayData = "bdate"
        case homeTown = "home_town"
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

enum RelationUser: Int, Decodable {
    case none = 0
    case notMarried = 1
    case haveFriend = 2
    case engaged = 3
    case married = 4
    case difficult = 5
    case activelySearching = 6
    case love = 7
    case inCivinMarriage = 8
    
    func getStatus(sex: Int?) -> String? {
        switch self {
            case .notMarried: return sex == 1 ? "не замужем" : sex == 2 ? "не женат" : ""
            case .haveFriend: return sex == 1 ? "есть друг" : sex == 2 ? "есть подруга" : ""
            case .engaged: return sex == 1 ? "помолвлена" : sex == 2 ? "помолвлен" : ""
            case .married: return sex == 1 ? "замужем" : sex == 2 ? "женат" : ""
            case .difficult: return "всё сложно"
            case .activelySearching: return "в активном поиске"
            case .love: return sex == 1 ? "влюблена" : sex == 2 ? "влюблён" : ""
            case .inCivinMarriage: return "в гражданском браке"
            case .none: return nil
        }
    }
}

struct PersonalInfo: Decodable {
    let langs: [String]?
}

struct RelativesInfo: Decodable {
    let id: Int?
    let name: String?
    let type: RelativesType
}

enum RelativesType: String, Decodable {
    case child
    case sibling
    case parent
    case grandparent
}

@propertyWrapper
struct DecodableBool {
    var wrappedValue = false
}

extension DecodableBool: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(Bool.self)
    }
}

extension KeyedDecodingContainer {
    func decode(_ type: DecodableBool.Type, forKey key: Key) throws -> DecodableBool {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}
