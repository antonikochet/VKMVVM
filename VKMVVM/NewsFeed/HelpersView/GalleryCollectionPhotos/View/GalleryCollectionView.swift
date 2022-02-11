//
//  GalleryCollectionView.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 04.01.2022.
//

import UIKit

protocol GalleryCollectionViewDelegate: AnyObject {
    func showDetailPhoto(at index: Int)
}

class GalleryCollectionView: UICollectionView {

    weak var galleryDelegate: GalleryCollectionViewDelegate?
    
    var modelView: GalleryModelViewType? {
        didSet {
            reloadData()
        }
    }
    
    init() {
        let rowLayout = RowLayout()
        super.init(frame: .zero, collectionViewLayout: rowLayout)
        rowLayout.delegate = self
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        delegate = self
        dataSource = self
        
        register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GalleryCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        galleryDelegate?.showDetailPhoto(at: indexPath.row)
    }
}

extension GalleryCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelView?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.identifier, for: indexPath) as! GalleryCollectionViewCell
        let photo = modelView?.get(by: indexPath.row)
        cell.set(imageUrl: photo?.photoURLString)
        return cell
    }
}

extension GalleryCollectionView: RowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPath indexPath: IndexPath) -> CGSize {
        guard let photo = modelView?.get(by: indexPath.row) else { return CGSize.zero }
        return CGSize(width: photo.width, height: photo.height)
    }

}
