//
//  PhotosRequestParams.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 24.01.2022.
//

import Foundation

enum PhotosRequestParams: String {
    case ownerId = "owner_id"
    case albumId = "album_id"
    case photoIds = "photo_ids"
    case extended
}

enum AlbumIdRequestParams {
    case wall
    case profile
    case saved
    case id(String)
    
    var string: String {
        switch self {
            case .wall:
                return "wall"
            case .profile:
                return "profile"
            case .saved:
                return "saved"
            case .id(let string):
                return string
        }
    }
}

enum GetAllPhotosRequestParams: String {
    case ownerId = "owner_id"
    case extended
    case offset
    case count
    case needHidden = "need_hidden"
    case skipHidden = "skip_hidden"
}
