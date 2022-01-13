//
//  DetailGalleryPhotosModelView.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 12.01.2022.
//

import Foundation

protocol DetailGalleryPhotosViewModelType {
    func getPhoto(at index: Int) -> DetailPhotoViewModelType?
    var count: Int { get }
    func getCurrectTitle(at index: Int) -> String?
}

class DetailGalleryPhotosModelView {
    private var photos: [NewsFeedCellPhotoAttachementViewModelType]
    
    init(_ photos: [NewsFeedCellPhotoAttachementViewModelType]) {
        self.photos = photos
    }
}

extension DetailGalleryPhotosModelView: DetailGalleryPhotosViewModelType {
    func getPhoto(at index: Int) -> DetailPhotoViewModelType? {
        guard index >= 0 && index < photos.count else { return nil }
        let photo = photos[index]
        return DetailGalleryPhotosModel(photoUrlString: photo.photoURLString)
    }
    
    var count: Int {
        photos.count
    }
    
    func getCurrectTitle(at index: Int) -> String? {
        guard index >= 0 && index < photos.count else { return nil }
        return "\(index + 1) из \(photos.count)"
    }
}
