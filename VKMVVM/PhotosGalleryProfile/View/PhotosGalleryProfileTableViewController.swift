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
}

class PhotosGalleryProfileTableViewController: UITableViewController {

    var viewModel: PhotosGalleryProfileViewModelType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(AlbumsViewCell.self, forCellReuseIdentifier: AlbumsViewCell.identifier)
        viewModel?.startLoadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumsViewCell.identifier, for: indexPath) as! AlbumsViewCell
        if let albumsViewModel = viewModel?.getAlbums() {
            cell.set(viewModel: albumsViewModel)
        }
        return cell
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height * 0.3
    }
}

extension PhotosGalleryProfileTableViewController: PhotosGalleryProfileDelegate {
    func didLoadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showError(_ error: Error) {
        print(error)
    }
    
    
}
