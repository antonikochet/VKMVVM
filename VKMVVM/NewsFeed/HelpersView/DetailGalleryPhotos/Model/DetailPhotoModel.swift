//
//  DetailGalleryPhotosModel.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 12.01.2022.
//

import Foundation

struct DetailPhotoModel: DetailPhotoViewModelType {
    var photoUrlString: String?
    var likes: String
    var comments: String
    var reposts: String
}
