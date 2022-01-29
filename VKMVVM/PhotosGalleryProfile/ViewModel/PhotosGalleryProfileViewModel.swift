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
    
    private var albumsResponse: AlbumResponse?
    private var albumsType: AlbumsCellViewModelType?
    
    init(userId: String?, dataFetcher: DataFetcher = NetworkDataFetcher()) {
        self.userId = userId
        self.dataFetcher = dataFetcher
    }
    
    private func getAlbumsProfile() {
        dataFetcher.getAlbums(ownerId: userId, photoSizes: true, needSystem: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let response):
                    self.albumsResponse = response.response
                    self.delegate?.didLoadData()
                case .failure(let error):
                    self.delegate?.showError(error)
            }
        }
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
    
    func startLoadData() {
        self.getAlbumsProfile()
    }
}
