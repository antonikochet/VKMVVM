//
//  AlbumsViewCell.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 29.01.2022.
//

import UIKit

protocol AlbumsCellViewModelType {
    var count: Int { get }
    var albums: [AlbumCellViewModelType] { get }
}

class AlbumsViewCell: UITableViewCell {

    static let identifier = "AlbumsViewCell"
    
    private var viewModel: AlbumsCellViewModelType?
    
    private let headerView: HeaderCell = {
        let view = HeaderCell(title: "Альбомы")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let albumsCollectionView: UICollectionView = {
        let collLayout = UICollectionViewFlowLayout()
        collLayout.scrollDirection = .horizontal
        let collView = UICollectionView(frame: .zero, collectionViewLayout: collLayout)
        collView.register(AlbumViewCell.self, forCellWithReuseIdentifier: AlbumViewCell.identifier)
        collView.translatesAutoresizingMaskIntoConstraints = false
        return collView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(headerView)
        contentView.addSubview(albumsCollectionView)
        
        albumsCollectionView.dataSource = self
        albumsCollectionView.delegate = self
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: StaticSizesUniversalViews.topConstantLabelCell),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: StaticSizesUniversalViews.fontLabelCell.lineHeight),
        
            albumsCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: StaticSizesUniversalViews.topConstantContentCell),
            albumsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            albumsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            albumsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(viewModel: AlbumsCellViewModelType) {
        self.viewModel = viewModel
        headerView.set(count: viewModel.count.description)
        albumsCollectionView.reloadData()
    }
}

extension AlbumsViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumViewCell.identifier, for: indexPath) as! AlbumViewCell
        if let viewModel = viewModel {
            cell.set(viewModel: viewModel.albums[indexPath.row])
        }
        return cell
    }
    
}

extension AlbumsViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.height - (StaticSizesUniversalViews.topConstantLabelCell +
                                                    StaticSizesUniversalViews.fontLabelCell.lineHeight +
                                                    StaticSizesUniversalViews.topConstantContentCell)
        return CGSize(width: height * 1.25, height: height)
    }
}
