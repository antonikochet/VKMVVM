//
//  PhotosGalleryProfileModel.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 29.01.2022.
//

import Foundation

struct AlbumCellModel: AlbumCellViewModelType {
    var thumbUrl: String?
    var nameAlbum: String
    var countPhotos: String
}

struct AlbumsCellModel: AlbumsCellViewModelType {
    var count: Int
    var albums: [AlbumCellViewModelType]
}
