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

enum AlbumIdRequestParams: String {
    case wall
    case profile
    case saved
}
