//
//  PhotosGalleryProfileViewModel.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 29.01.2022.
//

import Foundation

protocol PhotosGalleryProfileDelegate: AnyObject {
    func didLoadData()
    func showError(_ error: Error)
}

class PhotosGalleryProfileViewModel {
    
    weak var delegate: PhotosGalleryProfileDelegate?
    
    private var dataFetcher: DataFetcher
    private var userId: String?
    private let dispatchGroup = DispatchGroup()
    private var albumsResponse: AlbumResponse?
    private var photos: [Photo]
    private var photosViewModel: PhotosCellViewModelType?
    
    init(userId: String?, photos: [Photo] = [], dataFetcher: DataFetcher = NetworkDataFetcher()) {
        self.userId = userId
        self.dataFetcher = dataFetcher
        self.photos = photos
    }
    
    private func getAlbumsProfile() {
        dispatchGroup.enter()
        dataFetcher.getAlbums(ownerId: userId, photoSizes: true, needSystem: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let response):
                    self.albumsResponse = response.response
                case .failure(let error):
                    self.delegate?.showError(error)
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func getAllPhotosProfile(offset: Int, count: Int? = nil) {
        dispatchGroup.enter()
        dataFetcher.getAllPhotos(ownerId: userId, extended: true, offset: offset, count: count, skipHidden: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let response):
                    let photoResponse = response.response
                    self.photos.append(contentsOf: photoResponse.items)
                    if (photoResponse.more ?? 0) == 1 {
                        let realOffset = photoResponse.items.max { $0.realOffset ?? 0 < $1.realOffset ?? 0 }?.realOffset
                        if let realOffset = realOffset {
                            var count = photoResponse.count - photoResponse.items.count
                            count = count <= 200 ? count : 200
                            self.getAllPhotosProfile(offset: realOffset + 1, count: count)
                        } else {
                            self.formatterPhotoList()
                        }
                    } else {
                            self.formatterPhotoList()
                    }
                case .failure(let error):
                    self.delegate?.showError(error)
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func formatterPhotoList() {
        let urlPhotos = photos.map { $0.srcBIG }
        self.photosViewModel = PhotosCellModel(count: photos.count,
                                              urlPhotos: urlPhotos)
    }
}

extension PhotosGalleryProfileViewModel: PhotosGalleryProfileViewModelType {
    func getAlbums() -> AlbumsCellViewModelType? {
        guard let response = albumsResponse else { return nil }
        let albums = response.items.map { album -> AlbumCellViewModelType in
            let urlPhoto = album.sizes?.first(where: { $0.type == "x" })?.url
            return AlbumCellModel(thumbUrl: urlPhoto,
                                  nameAlbum: album.title,
                                  countPhotos: String(album.size))
        }
        let viewModel = AlbumsCellModel(count: response.count,
                                        albums: albums)
        return viewModel
    }
    
    func getPhotos() -> PhotosCellViewModelType? {
        return photosViewModel
    }
    
    func startLoadData() {
        self.getAlbumsProfile()
        self.getAllPhotosProfile(offset: 0)
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.delegate?.didLoadData()
        }
    }
}
