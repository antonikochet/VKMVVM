//
//  AlbumsResponse.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 26.01.2022.
//

import Foundation

struct AlbumResponseWrapper: Decodable {
    let response: AlbumResponse
}

struct AlbumResponse: Decodable {
    let count: Int
    let items: [Album]
}

struct Album: Decodable {
    let id: Int
    let ownerId: Int
    let title: String
    let size: Int
    let sizes: [AlbumThumbSize]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, size, sizes
        case ownerId = "owner_id"
    }
}

struct AlbumThumbSize: Decodable {
    let url: String
    let height: Int
    let width: Int
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case height, width, type
        case url = "src"
    }
}
