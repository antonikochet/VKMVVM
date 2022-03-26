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
    func changedLike(at indexPhoto: Int)
    
    var changeLike: ((DetailPhotoViewModelType, Int) -> Void)? { get set }
    var showError: ((String) -> Void)? { get set }
}

class DetailGalleryPhotosModelView {
    
    var changeLike: ((DetailPhotoViewModelType, Int) -> Void)?
    var showError: ((String) -> Void)?
    
    private var photos: [DetailPhotoViewModelType] = []
    
    private var dataFetcher: DataFetcher
    
    init(_ photos: [Photo], dataFetcher: DataFetcher = NetworkDataFetcher()) {
        self.dataFetcher = dataFetcher
        processPhotos(photos)
    }
    
    private func changeLikePhoto(ownerId: Int, itemId: Int, isLiked: Bool) {
        let request = LikesRequestParams(type: .photo,
                                         ownerId: ownerId,
                                         itemId: itemId)
        let typeMethod: LikesTypeMethod = isLiked ? .delete : .add
        dataFetcher.handlingLike(type: typeMethod ,parametrs: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let responseWrapper):
                    let indexCell = self.photos.firstIndex(where: { ($0 as! DetailPhotoModel).id == itemId })
                    if let indexCell = indexCell {
                        var viewModel = self.photos[indexCell] as! DetailPhotoModel
                        viewModel.likes = String(responseWrapper.response.likes)
                        viewModel.isLiked = !viewModel.isLiked
                        self.photos[indexCell] = viewModel
                        viewModel.isChangedLike = true
                        self.changeLike?(viewModel, indexCell)
                    }
                case .failure(let error):
                    self.showError?(error.localizedDescription)
            }
        }
    }
    
    private func processPhotos(_ photos: [Photo]) {
        self.photos = photos.map { photo in
            DetailPhotoModel(id: photo.id,
                             ownerId: photo.ownerId,
                             photoUrlString: photo.srcBIG,
                             likes: photo.likes?.count.description ?? "",
                             isLiked: photo.likes?.isLiked ?? false,
                             isChangedLike: false,
                             comments: photo.comments?.count.description ?? "",
                             reposts: photo.reposts?.count.description ?? "")
        }
    }
}

extension DetailGalleryPhotosModelView: DetailGalleryPhotosViewModelType {
    func getPhoto(at index: Int) -> DetailPhotoViewModelType? {
        guard index >= 0 && index < photos.count else { return nil }
        return photos[index]
    }
    
    var count: Int {
        photos.count
    }
    
    func getCurrectTitle(at index: Int) -> String? {
        guard index >= 0 && index < photos.count else { return nil }
        return "\(index + 1) из \(photos.count)"
    }
    
    func changedLike(at index: Int) {
        let photo = photos[index] as! DetailPhotoModel
        self.changeLikePhoto(ownerId: photo.ownerId, itemId: photo.id, isLiked: photo.isLiked)
    }
}
