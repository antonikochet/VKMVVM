//
//  PhotosViewCell.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 30.01.2022.
//

import UIKit

protocol PhotosCellViewModelType {
    var count: Int { get }
    var urlPhotos: [String?] { get }
}

protocol PhotosViewCellDelegate: AnyObject {
    func showDetailGalleryPhotos(index: Int)
}

class PhotosViewCell: UITableViewCell {
    
    static let identifier = "PhotosViewCell"

    weak var delegate: PhotosViewCellDelegate?
    
    private var viewModel: PhotosCellViewModelType? {
        didSet {
            photosCollectionView.reloadData()
        }
    }
    
    private let headerView: HeaderCell = {
        let view = HeaderCell(title: "Все фотографии")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collView.register(PhotoViewCell.self, forCellWithReuseIdentifier: PhotoViewCell.identifier)
        collView.translatesAutoresizingMaskIntoConstraints = false
        collView.isScrollEnabled = false
        return collView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.addSubview(headerView)
        contentView.addSubview(photosCollectionView)
        
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        
        headerView.setupConstraints(superView: contentView)
        NSLayoutConstraint.activate([
            photosCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: StaticSizesUniversalViews.topConstantContentCell),
            photosCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photosCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photosCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(viewModel: PhotosCellViewModelType) {
        self.viewModel = viewModel
        headerView.set(count: String(viewModel.count))
    }
}

extension PhotosViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoViewCell.identifier, for: indexPath) as! PhotoViewCell
        let urlImage = viewModel?.urlPhotos[indexPath.row]
        cell.set(urlImage: urlImage)
        return cell
    }
}

extension PhotosViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.showDetailGalleryPhotos(index: indexPath.row)
    }
}

extension PhotosViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CalculatorSizes.calculateSizePhotoCell(widthSuperView: collectionView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CalculatorSizes.paddingCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CalculatorSizes.paddingCell
    }
}

extension PhotosViewCell {
    struct CalculatorSizes {
        
        static var itemsPerRow: CGFloat = 3
        static var paddingCell: CGFloat = 3
        
        static func calculateHeightPhotosViewCell(widthSuperView: CGFloat, countPhotos: Int) -> CGFloat {
            let heightCellAbovePhotos = (StaticSizesUniversalViews.topConstantLabelCell +
                                         StaticSizesUniversalViews.fontLabelCell.lineHeight +
                                         StaticSizesUniversalViews.topConstantContentCell)
            
            let sizeCell = calculateSizePhotoCell(widthSuperView: widthSuperView)
            
            let itemsInColomn: CGFloat = (CGFloat(countPhotos) / itemsPerRow).rounded(.up)
            let paddingSpaceColomn = paddingCell * (itemsInColomn - 1)
            let heightColomn = sizeCell.height * itemsInColomn + paddingSpaceColomn
            
            return heightCellAbovePhotos + heightColomn
        }
        
        static func calculateSizePhotoCell(widthSuperView: CGFloat) -> CGSize {
            let paddingSpace = paddingCell * (itemsPerRow - 1)
            let availableWidth = widthSuperView - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            
            return CGSize(width: widthPerItem, height: widthPerItem)
        }
    }
}

