//
//  Photo.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 24.01.2022.
//

import Foundation

struct Photo: Decodable {
    let id: Int
    let ownerId: Int
    let sizes: [PhotoSize]
    let date: Int
    let albumId: Int
    let likes: LikesItem?
    let comments: CountableItem?
    let reposts: CountableItem?
    let realOffset: Int?
    
    var height: Int {
         return getPropperSize().height
    }
    
    var width: Int {
        return getPropperSize().width
    }
    
    var srcBIG: String {
         return getPropperSize().url
    }
    
    private func getPropperSize() -> PhotoSize {
        if let sizeX = sizes.first(where: { $0.type == "x" }) {
            return sizeX
        } else if let fallBackSize = sizes.last {
             return fallBackSize
        } else {
            return PhotoSize(type: "wrong image", url: "wrong image", width: 0, height: 0)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case sizes, date, likes, comments, reposts, id
        case ownerId = "owner_id"
        case albumId = "album_id"
        case realOffset = "real_offset"
    }
}

struct PhotoSize: Decodable {
    let type: String
    let url: String
    let width: Int
    let height: Int
}
