//
//  PhotosGalleryProfileViewCell.swift
//  VKMVVM
//
//  Created by Антон Кочетков on 26.01.2022.
//

import UIKit

protocol PhotoListViewModelType {
    var countPhoto: String { get }
    var photoList: [DetailPhotoViewModelType] { get }
}

protocol PhotosGalleryProfileViewCellDelegate: AnyObject {
    func showDetailPhotos(beginIndex: Int)
}

class PhotosGalleryProfileViewCell: UITableViewCell {

    static let identifier = "PhotosGalleryProfileViewCell"
    
    weak var delegate: PhotosGalleryProfileViewCellDelegate?
    
    private var viewModel: PhotoListViewModelType? {
        didSet {
            photosCollectionView.reloadData()
        }
    }
    
    private let headerView: HeaderCell = {
        let view = HeaderCell(title: "ФОТОГРАФИИ")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collView.showsHorizontalScrollIndicator = false
        collView.showsVerticalScrollIndicator = false
        collView.isScrollEnabled = false
        collView.translatesAutoresizingMaskIntoConstraints = false
        return collView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.addSubview(headerView)
        contentView.addSubview(photosCollectionView)
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        
        headerView.setupConstraints(superView: contentView)
        NSLayoutConstraint.activate([
            photosCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            photosCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photosCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photosCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(viewModel: PhotoListViewModelType) {
        headerView.set(count: viewModel.countPhoto)
        self.viewModel = viewModel
    }
}

extension PhotosGalleryProfileViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photoList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        if let photoViewModel = viewModel?.photoList[indexPath.row] {
            cell.set(imageURL: photoViewModel.photoUrlString)
        }
        return cell
    }
}

extension PhotosGalleryProfileViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.showDetailPhotos(beginIndex: indexPath.row)
    }
}

extension PhotosGalleryProfileViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CalculatorSizes.calculateSizeCellPhoto(widthSuperView: frame.width - (CalculatorSizes.paddingCollectionView.left + CalculatorSizes.paddingCollectionView.right))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CalculatorSizes.paddingItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CalculatorSizes.paddingItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return CalculatorSizes.paddingCollectionView
    }
}

extension PhotosGalleryProfileViewCell {
    struct CalculatorSizes {
    
        static let paddingItem: CGFloat = 3
        static let paddingCollectionView = UIEdgeInsets(top: StaticSizesUniversalViews.topConstantContentCell,
                                                        left: 8, bottom: 0, right: 8)
        
        private static let itemsPerRow: CGFloat = 3
        private static let itemsInColomn: CGFloat = 2
    
        static func calculateHeightPhotosGalleryCell(widthSuperView: CGFloat) -> CGFloat {
            let heightCell = (StaticSizesUniversalViews.topConstantLabelCell +
                              StaticSizesUniversalViews.fontLabelCell.lineHeight)
            
            let sizeCell = calculateSizeCellPhoto(widthSuperView: widthSuperView)
            
            let paddingSpaceColomn = paddingItem * (itemsInColomn - 1)
            let heightColomn = sizeCell.height * itemsInColomn + paddingSpaceColomn
            
            return heightCell + heightColomn
        }
        
        static func calculateSizeCellPhoto(widthSuperView: CGFloat) -> CGSize {
            let paddingSpace = paddingItem * (itemsPerRow + 1)
            let availableWidth = widthSuperView - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            
            return CGSize(width: widthPerItem, height: widthPerItem)
        }
    }
}
