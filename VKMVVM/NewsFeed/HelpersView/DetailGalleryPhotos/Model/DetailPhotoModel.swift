//
//  DetailGalleryPhotosModel.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 12.01.2022.
//

import Foundation

struct DetailPhotoModel: DetailPhotoViewModelType {
    var id: Int
    var ownerId: Int
    
    var photoUrlString: String?
    var likes: String
    var isLiked: Bool
    var isChangedLike: Bool
    var comments: String
    var reposts: String
}
