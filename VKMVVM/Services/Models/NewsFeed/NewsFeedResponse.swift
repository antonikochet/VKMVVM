//
//  NewsFeedAPIModel.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 20.12.2021.
//

import Foundation

struct NewsFeedResponseWrapped: Decodable {
    let response: NewsFeedResponse
}

struct NewsFeedResponse: Decodable {
    var items: [NewsFeedItem]
    var profiles: [Profile]
    var groups: [Group]
    var nextFrom: String?
    
    enum CodingKeys: String, CodingKey {
        case items, profiles, groups
        case nextFrom = "next_from"
    }
}

struct NewsFeedItem: Decodable {
    let sourceId: Int
    let postId: Int
    let text: String?
    let date: Double
    let comments: CountableItem?
    let likes: CountableItem?
    let reposts: CountableItem?
    let views: CountableItem?
    let attachments: [Attechment]?
    
    enum CodingKeys: String, CodingKey {
        case text, date, comments, likes, reposts, views, attachments
        case sourceId = "source_id"
        case postId = "post_id"
    }
}

struct Attechment: Decodable {
    let photo: Photo?
}

struct CountableItem: Decodable {
    let count: Int
}

protocol ProfileRepresenatable {
    var id: Int { get }
    var name: String { get }
    var photo: String { get }
}

struct Profile: Decodable, ProfileRepresenatable {
    let id: Int
    let firstName: String
    let lastName: String
    let photo100: String
    
    var name: String { return firstName + " " + lastName }
    var photo: String { return photo100 }
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo100 = "photo_100"
    }
}

struct Group: Decodable, ProfileRepresenatable {
    let id: Int
    let name: String
    let photo100: String
    
    var photo: String { return photo100 }
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case photo100 = "photo_100"
    }
}
