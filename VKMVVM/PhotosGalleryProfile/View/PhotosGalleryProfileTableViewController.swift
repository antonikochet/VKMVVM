//
//  TableViewController.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 29.01.2022.
//

import UIKit

protocol PhotosGalleryProfileViewModelType {
    func startLoadData()
    func getAlbums() -> AlbumsCellViewModelType?
    func getPhotos() -> PhotosCellViewModelType?
    func getPhotosForDetailShow() -> [Photo]
    
    var didLoadData: (() -> Void)? { get set }
    var showError: ((String) -> Void)? { get set }
}

class PhotosGalleryProfileTableViewController: UITableViewController {

    var viewModel: PhotosGalleryProfileViewModelType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateViewModel()
        tableView.register(AlbumsViewCell.self, forCellReuseIdentifier: AlbumsViewCell.identifier)
        tableView.register(PhotosViewCell.self, forCellReuseIdentifier: PhotosViewCell.identifier)
        viewModel?.startLoadData()
        navigationItem.title = "Фотографии"
    }

    private func configurateViewModel() {
        viewModel?.didLoadData = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel?.showError = { message in
            print(message)
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath {
            case IndexPath(row: 0, section: 0):
                let cell = tableView.dequeueReusableCell(withIdentifier: AlbumsViewCell.identifier, for: indexPath) as! AlbumsViewCell
                if let albumsViewModel = viewModel?.getAlbums() {
                    cell.set(viewModel: albumsViewModel)
                }
                return cell
            case IndexPath(row: 1, section: 0):
                let cell = tableView.dequeueReusableCell(withIdentifier: PhotosViewCell.identifier, for: indexPath) as! PhotosViewCell
                if let photosViewModel = viewModel?.getPhotos() {
                    cell.set(viewModel: photosViewModel)
                    cell.delegate = self
                }
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
                return cell
        }
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
            case IndexPath(row: 0, section: 0):
                return tableView.frame.height * 0.3
            case IndexPath(row: 1, section: 0):
                return PhotosViewCell.CalculatorSizes.calculateHeightPhotosViewCell(widthSuperView: tableView.frame.width, countPhotos: viewModel?.getPhotos()?.count ?? 0)
            default:
                return 0
        }
    }
}

extension PhotosGalleryProfileTableViewController: PhotosViewCellDelegate {
    func showDetailGalleryPhotos(index: Int) {
        guard let photos = viewModel?.getPhotosForDetailShow(), !photos.isEmpty else { return }
        let vc = Configurator.configuratorGalleryPhotos(photos: photos, beginIndexPhoto: index)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
