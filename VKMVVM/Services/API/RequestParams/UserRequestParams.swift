//
//  UserRequestParams.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 16.01.2022.
//

import Foundation

struct UserRequestParams: RequestParamsProtocol {
   
    let userIds: String?
    let fields: [UserRequestFieldsParams]
    
    func generateParametrsForRequest() -> Parametrs {
        var paramets: Parametrs = [:]
        paramets[NameRequestParams.fields.rawValue] = UserRequestFieldsParams.params(fields)
        if let userIds = userIds {
            paramets[NameRequestParams.userIds.rawValue] = userIds
        }
        return paramets
    }
    
    private enum NameRequestParams: String {
        case userIds = "user_ids"
        case fields
    }
}

struct UsersGetFollowersRequestParams: RequestParamsProtocol {
    
    let userId: String?
    let fields: [UserRequestFieldsParams]
    
    func generateParametrsForRequest() -> Parametrs {
        var parametrs: Parametrs = [:]
        if let userId = userId {
            parametrs[NameRequestParams.userId.rawValue] = userId
        }
        if !fields.isEmpty {
            parametrs[NameRequestParams.fields.rawValue] = UserRequestFieldsParams.params(fields)
        }
        
        return parametrs
    }
    
    private enum NameRequestParams: String {
        case userId = "user_id"
        case fields
    }
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
