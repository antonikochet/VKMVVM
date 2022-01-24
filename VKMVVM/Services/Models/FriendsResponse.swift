//
//  FriendsResponse.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 19.01.2022.
//

import Foundation

struct FriendsResponseWrapper: Decodable {
    let response: FriendsResponse
}

struct FriendsResponse: Decodable {
    let count: Int
    let items: [UserResponse]
    
    var userId: String?
}
