//
//  GalleryModelView.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 04.01.2022.
//

import Foundation

protocol GalleryModelViewType: AnyObject {
    var count: Int { get }
    func get(by index: Int) -> NewsFeedCellPhotoAttachementViewModelType
}

class GalleryModelView {
    private var photos: [NewsFeedCellPhotoAttachementViewModelType]
    
    init(_ photos: [NewsFeedCellPhotoAttachementViewModelType]) {
        self.photos = photos
    }
}

extension GalleryModelView: GalleryModelViewType {
    var count: Int {
        return photos.count
    }
    
    func get(by index: Int) -> NewsFeedCellPhotoAttachementViewModelType {
        return photos[index]
    }
}
